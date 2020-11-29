--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("composer.containers.quests.quest_grid")
require("composer.containers.quests.quest_table")
require("router.filters.constant")
require("router.filters.path")
require("structs.quest.attributes.action")
require("structs.quest.attributes.property")
require("structs.quest.attributes.requirement")
require("structs.quest.properties")
require("structs.quest.quest")
require("utils.logger.file")
require("utils.provider.xml.provider")
require("utils.struct.table")

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
    _job = 1,
    _interval = CQuestRequirement.set_repeatable,
    _end = CQuestRequirement.set_date_access,
    _startscript = CQuestRequirement.set_script,
    _endscript = CQuestRequirement.set_script
}

local tAttrList = {
    _item = CQuestProperty.add_item,
    _skill = CQuestProperty.add_skill,
    _mob = CQuestProperty.add_mob,
    _quest = CQuestProperty.add_quest,
    _job = CQuestRequirement.set_jobs
}

local ttsAttrKey = {
    _item = {id = 0, count = 0},
    _skill = {id = 0},
    _mob = {id = 0, count = 0},
    _quest = {id = 0, state = 0}
}

local function read_quest_attribute_value(fn_attr, pQuestProps, pNode)
    local iValue = pNode:get_value()
    fn_attr(pQuestProps, iValue)
end

local function read_quest_attribute_item_value(pTabListItemNode, sKey, iDef)
    local pAttrNode = pTabListItemNode:get_child_by_name(sKey)

    local iVal
    if pAttrNode ~= nil then
        iVal = pAttrNode:get_value()
    else
        iVal = iDef
    end

    return iVal
end

local function read_quest_attribute_list(fn_attr, tsAttrKey, pQuestProps, pNode)
    for _, pTabListItemNode in pairs(pNode:get_children()) do
        local aiAttrList = {}
        for sKey, iDef in pairs(tsAttrKey) do
            local iVal = read_quest_attribute_item_value(pTabListItemNode, sKey, iDef)
            table.insert(aiAttrList, iVal)
        end

        fn_attr(pQuestProps, unpack(aiAttrList))
    end
end

local function read_quest_attribute_array(fn_attr, pQuestProps, pNode)
    local aiAttrList = {}

    local i = 0
    while true do
        local sKey = tostring(i)

        local iVal = read_quest_attribute_item_value(pNode, sKey)
        if iVal == nil then
            break
        end
        i = i + 1

        table.insert(aiAttrList, iVal)
    end

    fn_attr(pQuestProps, aiAttrList)
end

local function read_quest_tab_node_attribute(pQuestProps, pNode)
    local sName = '_' .. pNode:get_name()

    local fn_attr = tAttrUnit[sName]
    if fn_attr ~= nil then
        if fn_attr == 0 then
            fn_attr = tAttrList[sName]
            local tsAttrKey = ttsAttrKey[sName]

            read_quest_attribute_list(fn_attr, tsAttrKey, pQuestProps, pNode)
        elseif fn_attr == 1 then
            fn_attr = tAttrList[sName]

            read_quest_attribute_array(fn_attr, pQuestProps, pNode)
        else
            read_quest_attribute_value(fn_attr, pQuestProps, pNode)
        end
    end
end

local function read_quest_tab_state_node(pQuestProps, pTabStateNode)
    for _, pTabElementNode in pairs(pTabStateNode:get_children()) do
        read_quest_tab_node_attribute(pQuestProps, pTabElementNode)
    end
end

local function read_quest_tab_node(sTabName, pQuestActProp, pQuestChkProp, pActNode, pChkNode)
    local pTabActNode = pActNode:get_child_by_name(sTabName)
    read_quest_tab_state_node(pQuestActProp, pTabActNode)

    local pTabChkNode = pChkNode:get_child_by_name(sTabName)
    read_quest_tab_state_node(pQuestChkProp, pTabChkNode)
end

local function read_quest_tab(sTabName, fn_quest_tab, pQuest, pActNode, pChkNode, rgfn_req_get, rgfn_act_get)
    local pQuestActProp = CQuestAction:new()
    local pQuestChkProp = CQuestRequirement:new()
    local pQuestTab = fn_quest_tab(pQuest)

    read_quest_tab_node(sTabName, pQuestActProp, pQuestChkProp, pActNode, pChkNode)

    pQuestTab:set_requirement(pQuestChkProp, rgfn_req_get)
    pQuestTab:set_action(pQuestActProp, rgfn_act_get)
end

local function read_quest_node(pActNode, pChkNode, rgfn_req_get, rgfn_act_get)
    local iQuestid = pActNode:get_name_tonumber()
    local pQuest = CQuest:new({
        iQuestid = iQuestid,
        qpStart = CQuestProperties:new({iQuestid = iQuestid, bStart = true}),
        qpEnd = CQuestProperties:new({iQuestid = iQuestid, bStart = false})
    })

    read_quest_tab("0", CQuest.get_start, pQuest, pActNode, pChkNode, rgfn_req_get, rgfn_act_get)
    read_quest_tab("1", CQuest.get_end, pQuest, pActNode, pChkNode, rgfn_req_get, rgfn_act_get)

    return pQuest
end

local function read_quests(ctQuests, pActNode, pChkNode)
    local pActImgNode = pActNode:get_child_by_name("Act.img")
    local pChkImgNode = pChkNode:get_child_by_name("Check.img")

    local rgfn_req_get = fetch_property_get_methods(CQuestRequirement)
    local rgfn_act_get = fetch_property_get_methods(CQuestAction)

    for _, pActQuestNode in pairs(pActImgNode:get_children()) do
        local pChkQuestNode = pChkImgNode:get_child_by_name(pActQuestNode:get_name())
        if pChkQuestNode ~= nil then
            local pQuest = read_quest_node(pActQuestNode, pChkQuestNode, rgfn_req_get, rgfn_act_get)
            ctQuests:add_quest(pQuest)
        else
            log(LPath.FALLBACK, "quest.txt", "[WARNING] Missing questid " .. pActQuestNode:get_name())
        end
    end
end

local function init_quests_list(pActNode, pChkNode)
    local ctQuests = CQuestTable:new()

    read_quests(ctQuests, pActNode, pChkNode)

    return ctQuests
end

local function get_first_field_value(tpNpcMapid)
    for _, v in pairs(tpNpcMapid) do
        return v
    end

    return -1
end

local function apply_npc_town_fields_only(tpNpcMapid, ctFieldsMeta)
    for iContinentid, iMapid in pairs(tpNpcMapid:get_entry_set()) do
        if not ctFieldsMeta:is_town(iMapid) then
            tpNpcMapid:remove(iContinentid)
        end
    end
end

local function apply_npc_field(pQuest, iStartNpc, ctNpcs, ctFieldsMeta, tpNpcField, fn_get_quest_tab)
    -- selects main areas in a bundle of locations

    local pTab = fn_get_quest_tab(pQuest)
    local pRequirement = pTab:get_requirement()
    local iReqNpc = pRequirement:get_npc()

    if iReqNpc > -1 then        -- keep same npc from start requirement if not found
        iStartNpc = iReqNpc
    end

    local pNpcMapid = tpNpcField[iStartNpc]
    if pNpcMapid == nil then
        local tpNpcFields = ctNpcs:get_locations(iStartNpc)

        if tpNpcFields ~= nil then
            local tpNpcMapid = STable:new()
            local bHasTown = false
            for iMapid, _ in pairs(tpNpcFields) do
                local bTown = ctFieldsMeta:is_town(iMapid)
                bHasTown = bHasTown or bTown

                if tpNpcMapid:get(get_continent_id(iMapid)) == nil then
                    tpNpcMapid:insert(get_continent_id(iMapid), iMapid)
                elseif bTown then
                    tpNpcMapid:insert(get_continent_id(iMapid), iMapid)
                end
            end

            -- make sure only towns listed if there's at least one town in
            if bHasTown then
                apply_npc_town_fields_only(tpNpcMapid, ctFieldsMeta)
            end

            if tpNpcMapid:size() < 2 then
                tpNpcField[iStartNpc] = get_first_field_value(tpNpcMapid:get_entry_set())
            else
                tpNpcField[iStartNpc] = tpNpcMapid:get_entry_set()
            end

            -- pNpcMapid: [integer - 1 value][dict - 1 per region]
            pNpcMapid = tpNpcField[iStartNpc]
        else
            log(LPath.FALLBACK, "npc.txt", "[WARNING] NPC locations not found for NPCID " .. iStartNpc)
        end
    end

    pRequirement:set_field(pNpcMapid)
end

local function should_supress_quest(pQuest)
    -- ignore date expiring quests
    local bHasDate = pQuest:get_start():get_requirement():has_date_access()
    if (bHasDate) then
        return true
    end

    return false
end

function apply_quest_npc_field_areas(ctQuests, ctNpcs, ctFieldsMeta)
    local tQuests = ctQuests:get_quests()
    local tpNpcField = {}

    for _, pQuest in pairs(tQuests) do
        if not should_supress_quest(pQuest) then
            local iStartNpc = pQuest:get_start():get_requirement():get_npc()

            apply_npc_field(pQuest, iStartNpc, ctNpcs, ctFieldsMeta, tpNpcField, CQuest.get_start)
            apply_npc_field(pQuest, iStartNpc, ctNpcs, ctFieldsMeta, tpNpcField, CQuest.get_end)
        end
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

local function randomize_quest_table_by_level(pGridQuests)
    -- same level quests appears in arbitrary order

    pGridQuests:randomize_quest_table()
    pGridQuests:sort_quest_table()
end

function load_grid_quests(ctQuests)
    local pGridQuests = CQuestGrid:new(ctQuests)
    randomize_quest_table_by_level(pGridQuests)

    return pGridQuests
end
