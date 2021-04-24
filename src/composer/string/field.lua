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

local function load_field_names(pMapStringNode, tsMapName, tsStreetName)
    local pMapStringNode = pMapStringNode:get_child_by_name("Map.img")

    for _, pRegionNode in pairs(pMapStringNode:get_children()) do
        for _, pFieldNode in pairs(pRegionNode:get_children()) do
            local iMapid = pFieldNode:get_name_tonumber()

            local sStreetName = pFieldNode:get_child_by_name("streetName"):get_value()
            local sMapName = pFieldNode:get_child_by_name("mapName"):get_value()

            tsMapName[iMapid] = sMapName
            tsStreetName[iMapid] = sStreetName
        end
    end
end

function load_field_string()
    local tsMapName = {}
    local tsStreetName = {}

    local sDirPath = RPath.RSC_STRINGS
    local sMapStringsPath = sDirPath .. "/Map.img.xml"

    local pMapStringNode = SXmlProvider:load_xml(sMapStringsPath)
    load_field_names(pMapStringNode, tsMapName, tsStreetName)

    SXmlProvider:unload_node(sDirPath)   -- free XMLs nodes: String

    return tsMapName, tsStreetName
end
