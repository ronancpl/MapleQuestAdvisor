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

local function load_npc_names(pNpcStringNode, tsNpcName)
    local pNpcListNode = pNpcStringNode:get_child_by_name("Npc.img")

    for _, pNpcNode in pairs(pNpcListNode:get_children()) do
        local iNpcid = pNpcNode:get_name_tonumber()

        local pNameNode = pNpcNode:get_child_by_name("name")
        local sNpcName = pNameNode and pNameNode:get_value() or ""

        tsNpcName[iNpcid] = sNpcName
    end
end

function load_npc_string()
    local tsNpcName = {}

    local sDirPath = RPath.RSC_STRINGS
    local sNpcStringsPath = sDirPath .. "/Npc.img.xml"

    local pNpcStringNode = SXmlProvider:load_xml(sNpcStringsPath)
    load_npc_names(pNpcStringNode, tsNpcName)

    SXmlProvider:unload_node(sDirPath)   -- free XMLs nodes: String

    return tsNpcName
end
