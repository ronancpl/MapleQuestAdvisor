--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("router.constants.path")
require("utils.provider.xml.provider")

local function load_quest_names(pQuestStringNode, tsQuestName)
    local pQuestListNode = pQuestStringNode:get_child_by_name("QuestInfo.img")

    for _, pQuestNode in pairs(pQuestListNode:get_children()) do
        local iQuestid = pQuestNode:get_name_tonumber()

        local pNameNode = pQuestNode:get_child_by_name("name")
        local sQuestName = pNameNode and pNameNode:get_value() or ""

        tsQuestName[iQuestid] = sQuestName
    end
end

function load_quest_string()
    local tsQuestName = {}

    local sDirPath = RPath.RSC_QUESTS
    local sQuestStringsPath = sDirPath .. "/QuestInfo.img.xml"

    local pQuestStringNode = SXmlProvider:load_xml(sQuestStringsPath)
    load_quest_names(pQuestStringNode, tsQuestName)

    SXmlProvider:unload_node(sDirPath)   -- free XMLs nodes: String

    return tsQuestName
end
