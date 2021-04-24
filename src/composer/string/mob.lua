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

local function load_mob_names(pMobStringNode, tsMobName)
    local pMobListNode = pMobStringNode:get_child_by_name("Mob.img")

    for _, pMobNode in pairs(pMobListNode:get_children()) do
        local iMobid = pMobNode:get_name_tonumber()

        local pNameNode = pMobNode:get_child_by_name("name")
        local sMobName = pNameNode and pNameNode:get_value() or ""

        tsMobName[iMobid] = sMobName
    end
end

function load_mob_string()
    local tsMobName = {}

    local sDirPath = RPath.RSC_STRINGS
    local sMobStringsPath = sDirPath .. "/Mob.img.xml"

    local pMobStringNode = SXmlProvider:load_xml(sMobStringsPath)
    load_mob_names(pMobStringNode, tsMobName)

    SXmlProvider:unload_node(sDirPath)   -- free XMLs nodes: String

    return tsMobName
end
