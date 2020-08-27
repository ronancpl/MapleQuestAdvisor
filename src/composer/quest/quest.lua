--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("router.filters.path")
require("structs.quest.attributes.action")
require("structs.quest.attributes.requirement")
require("structs.quest.properties")
require("structs.quest.quest")
require("structs.quest.quest_table")
require("utils.provider.xml.provider")

local tAttrUnit = {
    "exp" = CQuestProperty.set_exp,
    "money" = CQuestProperty.set_meso,
    "item" = 0,
    "skill" = 0,    -- attribute: list
    "mob" = 0,
    "pop" = CQuestProperty.set_fame,
    "npc" = CQuestRequirement.set_npc,
    "lvmin" = CQuestRequirement.set_level_min,
    "lvmax" = CQuestRequirement.set_level_max,
    "quest" = 0,
    "interval" = CQuestRequirement.set_repeatable,
    "end" = CQuestRequirement.set_date_access
}

local tAttrList = {
    "item" = CQuestProperty.add_item,
    "skill" = CQuestProperty.add_skill,
    "mob" = CQuestProperty.add_mob,
    "quest" = CQuestRequirement.add_quest
}

local function read_quest_attribute_value(fn_attr, pQuestProp, pNode)
    local iValue = pNode:get(sName)
    fn_attr(pQuestProp, iValue)
end

local function read_quest_attribute_list(fn_attr, pQuestProp, pNode)
    for _, pTabListItemNode in pairs(pNode:get_children()) do
        local iId = pTabListItemNode:get_child_by_name("id")
        local iCount = pTabListItemNode:get_child_by_name("count")

        fn_attr(pQuestProp, iId, iCount)
    end
end

local function read_quest_tab_node_attribute(pQuestProp, pNode)
    local sName = pNode:get_name()

    local fn_attr = tAttrUnit[sName]
    if fn_attr ~= 0 then
        read_quest_attribute_value(fn_attr, pQuestProp, pNode)
    else
        fn_attr = tAttrList[sName]
        read_quest_attribute_list(fn_attr, pQuestProp, pNode)
    end
end

local function read_quest_tab_state_node(pQuestTab, fn_addProperty, pTabStateNode, CStateProperty)
    for _, pTabElementNode in pairs(pTabStateNode:get_children()) do

        local pQuestProp = CStateProperty:new()
        read_quest_tab_node_attribute(pQuestProp, pTabElementNode)
        fn_addProperty(pQuestTab, pQuestProp)
    end
end

local function read_quest_tab_node(pQuestTab, sTabName, pActNode, pChkNode)
    local pTabActNode = pActNode:get_child_by_name(sTabName)
    read_quest_tab_state_node(pQuestTab, pQuestTab.add_action, pTabActNode, CQuestAction)

    local pTabChkNode = pChkNode:get_child_by_name(sTabName)
    read_quest_tab_state_node(pQuestTab, pQuestTab.add_requirement, pTabChkNode, CQuestRequirement)
end

local function read_quest_node(pActNode, pChkNode)
    local pQuest = CQuest:new()
    pQuest:set_questid(pActQuestNode:get_name_tonumber())

    read_quest_tab_node(pQuest:get_start(), "0", pActNode, pChkNode)
    read_quest_tab_node(pQuest:get_end(), "1", pActNode, pChkNode)

    return pQuest
end

local function read_quests(qtQuests, pActNode, pChkNode)
    local pActImgNode = pActNode:get_child_by_name("Act.img")
    local pChkImgNode = pActNode:get_child_by_name("Check.img")

    for _, pActQuestNode in pairs(pActImgNode:get_children()) do
        local pChkQuestNode = pChkImgNode:get_child_by_name(pActQuestNode:get_name())

        local pQuest = read_quest_node(pActQuestNode, pChkQuestNode)
        qtQuests:add_quest_data(pQuest)
    end
end

local function init_quests_list(pActNode, pChkNode)
    local qtQuests = CQuestTable:new()

    read_quests(qtQuests, pActNode, pChkNode)

    --qtQuests:randomize_quest_table()
    --qtQuests:sort_quest_table()

    return qtQuests
end

function load_resources_quests()
    local sDirPath = RPath.RSC_QUESTS
    local sActPath = sDirPath .. "/Act.img.xml"
    local sChkPath = sDirPath .. "/Check.img.xml"

    local pActNode = SXmlProvider:load_xml(sActPath)
    local pChkNode = SXmlProvider:load_xml(sChkPath)

    local qtQuests = init_quests_list(pActNode, pChkNode)

    SXmlProvider:unload_node(sDirPath)   -- free XMLs nodes: Act, Check
    return qtQuests
end
