--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("composer.containers.quests.quest_table")
require("router.filters.path")
require("structs.quest.attributes.action")
require("structs.quest.attributes.requirement")
require("structs.quest.properties")
require("structs.quest.quest")
require("utils.constants")
require("utils.table")
require("utils.provider.xml.provider")

local tAttrUnit = {
    _exp = CQuestProperty.set_exp,
    _money = CQuestProperty.set_meso,
    _item = 0,
    _skill = 0,    -- attribute: list
    _mob = 0,
    _pop = CQuestProperty.set_fame,
    _npc = CQuestRequirement.set_npc,
    _lvmin = CQuestRequirement.set_level_min,
    _lvmax = CQuestRequirement.set_level_max,
    _quest = 0,
    _interval = CQuestRequirement.set_repeatable,
    _end = CQuestRequirement.set_date_access
}

local tAttrList = {
    _item = CQuestProperty.add_item,
    _skill = CQuestProperty.add_skill,
    _mob = CQuestProperty.add_mob,
    _quest = CQuestProperty.add_quest
}

local ttsAttrKey = {
    _item = {id = 0, count = 0},
    _skill = {id = 0},
    _mob = {id = 0, count = 0},
    _quest = {id = 0, state = 0}
}

local function read_quest_attribute_value(fn_attr, pQuestProp, pNode)
    local iValue = pNode:get_value()
    fn_attr(pQuestProp, iValue)
end

local function read_quest_attribute_item_value(pTabListItemNode, sKey)
    local pAttrNode = pTabListItemNode:get_child_by_name(sKey)

    local iVal
    if pAttrNode ~= nil then
        iVal = pAttrNode:get_value()
    else
        iVal = iDef
    end

    return iVal
end

local function read_quest_attribute_list(fn_attr, tsAttrKey, pQuestProp, pNode)
    for _, pTabListItemNode in pairs(pNode:get_children()) do
        local aiAttrList = {}
        for sKey, iDef in pairs(tsAttrKey) do
            local iVal = read_quest_attribute_item_value(pTabListItemNode, sKey)
            table.insert(aiAttrList, iVal)
        end

        fn_attr(pQuestProp, unpack(aiAttrList))
    end
end

local function read_quest_tab_node_attribute(pQuestProp, pNode)
    local sName = '_' .. pNode:get_name()

    local fn_attr = tAttrUnit[sName]
    if fn_attr ~= nil then
        if fn_attr ~= 0 then
            read_quest_attribute_value(fn_attr, pQuestProp, pNode)
        else
            fn_attr = tAttrList[sName]
            local tsAttrKey = ttsAttrKey[sName]

            read_quest_attribute_list(fn_attr, tsAttrKey, pQuestProp, pNode)
        end
    end
end

local function read_quest_tab_state_node(pQuestProp, pTabStateNode)
    for _, pTabElementNode in pairs(pTabStateNode:get_children()) do
        read_quest_tab_node_attribute(pQuestProp, pTabElementNode)
    end
end

local function read_quest_tab_node(sTabName, pQuestActProp, pQuestChkProp, pActNode, pChkNode)
    local pTabActNode = pActNode:get_child_by_name(sTabName)
    read_quest_tab_state_node(pQuestActProp, pTabActNode)

    local pTabChkNode = pChkNode:get_child_by_name(sTabName)
    read_quest_tab_state_node(pQuestChkProp, pTabChkNode)
end

local function read_quest_tab(sTabName, fn_quest_tab, pQuest, pActNode, pChkNode)
    local pQuestActProp = CQuestAction:new()
    local pQuestChkProp = CQuestRequirement:new()
    local pQuestTab = fn_quest_tab(pQuest)

    read_quest_tab_node(sTabName, pQuestActProp, pQuestChkProp, pActNode, pChkNode)

    pQuestTab:set_requirement(pQuestChkProp)
    pQuestTab:set_action(pQuestActProp)
end

local function read_quest_node(pActNode, pChkNode)
    local pQuest = CQuest:new()
    pQuest:set_quest_id(pActNode:get_name_tonumber())

    read_quest_tab("0", CQuest.get_start, pQuest, pActNode, pChkNode)
    read_quest_tab("1", CQuest.get_end, pQuest, pActNode, pChkNode)

    return pQuest
end

local function read_quests(ctQuests, pActNode, pChkNode)
    local pActImgNode = pActNode:get_child_by_name("Act.img")
    local pChkImgNode = pChkNode:get_child_by_name("Check.img")

    for _, pActQuestNode in pairs(pActImgNode:get_children()) do
        local pChkQuestNode = pChkImgNode:get_child_by_name(pActQuestNode:get_name())
        if (pChkQuestNode ~= nil) then
            local pQuest = read_quest_node(pActQuestNode, pChkQuestNode)
            ctQuests:add_quest(pQuest)
        else
            print("[WARNING] Missing questid " .. pActQuestNode:get_name())
        end
    end
end

local function init_quests_list(pActNode, pChkNode)
    local ctQuests = CQuestTable:new()

    read_quests(ctQuests, pActNode, pChkNode)

    ctQuests:randomize_quest_table()    -- same level quests appears in arbitrary order
    ctQuests:sort_quest_table()

    return ctQuests
end

local function _get_first_field_value(tNpcMapid)
    for _, v in pairs(tNpcMapid) do
        return v
    end

    return -1
end

local function _apply_npc_town_fields_only(tNpcMapid, ctFieldsMeta)
    for k, v in pairs(tNpcMapid:get_entry_set()) do
        if not ctFieldsMeta:is_town(iMapid) then
            tNpcMapid:remove(k)
        end
    end
end

local function _apply_npc_field(pQuest, ctNpcs, ctFieldsMeta, tNpcField, fn_get_quest_tab)
    -- selects main areas in a bundle of locations

    local pTab = fn_get_quest_tab(pQuest)
    local pRequirement = pTab:get_requirement()
    local iStartNpc = pRequirement:get_npc()

    local pNpcMapid = tNpcField[iStartNpc]
    if pNpcMapid == nil then
        local tNpcFields = ctNpcs:get_locations(iStartNpc)

        local tNpcMapid = STable:new()
        local bHasTown = false
        for iMapid, _ in pairs(tNpcFields) do
            local bTown = ctFieldsMeta:is_town(iMapid)
            bHasTown = bHasTown or bTown

            if tNpcMapid:get(get_continent_id(iMapid)) == nil then
                tNpcMapid:insert(get_continent_id(iMapid), iMapid)
            elseif bTown then
                tNpcMapid:insert(get_continent_id(iMapid), iMapid)
            end
        end

        -- make sure only towns listed if there's at least one town in
        if bHasTown then
            _apply_npc_town_fields_only(tNpcMapid)
        end

        if tNpcMapid:size() < 2 then
            tNpcField[iStartNpc] = _get_first_field_value(tNpcMapid:get_entry_set())
        else
            tNpcField[iStartNpc] = tNpcMapid:get_entry_set()
        end

        -- pNpcMapid: [integer - 1 value][dict - 1 per region]
        pNpcMapid = tNpcField[iStartNpc]
    end

    pRequirement:set_field(pNpcMapid)
end

function apply_quest_npc_field_areas(ctQuests, ctNpcs, ctFieldsMeta)
    local rgQuests = ctQuests:get_quests()
    local tNpcField = {}

    for i = 1, rgQuests:size(), 1 do
        local pQuest = rgQuests:get(i)

        local pMapid = _get_npc_field(pQuest, ctNpcs, ctFieldsMeta, tNpcField, CQuest.get_start)
        _apply_npc_field(pQuest, ctNpcs, ctFieldsMeta, tNpcField, CQuest.get_end)
    end
end

function load_resources_quests()
    local sDirPath = RPath.RSC_QUESTS
    local sActPath = sDirPath .. "/Act.img.xml"
    local sChkPath = sDirPath .. "/Check.img.xml"

    local pActNode = SXmlProvider:load_xml(sActPath)
    local pChkNode = SXmlProvider:load_xml(sChkPath)

    local ctQuests = init_quests_list(pActNode, pChkNode)

    SXmlProvider:unload_node(sDirPath)   -- free XMLs nodes: Act, Check
    return ctQuests
end
