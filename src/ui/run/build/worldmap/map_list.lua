--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("ui.path.path")
require("composer.field.node.spot")
require("composer.field.node.text_box")
require("composer.field.node.media.image")
require("ui.struct.worldmap.element.path")

local function load_node_map_path(pMapNode, tpPathImgs, sRegionName, iIdx)
    local sXmlPath = RInterface.WMAP_DIR .. "/" .. sRegionName .. ".img/MapList/" .. iIdx .. "/path"
    local pImg = fetch_image_from_container(tpPathImgs, sXmlPath)

    local iOx
    local iOy
    local iZ
    local pPathNode = pMapNode:get_path()
    iOx, iOy, iZ = pPathNode:get_image()

    local pPath = CWmapElemPath:new()
    pPath:load(pImg, iOx, iOy, iZ, 0, 0)

    return pPath
end

local function load_node_mapno(pMapNode)
    local rgiFields = {}

    local pMapnoNode = pMapNode:get_mapno()
    for _, pNode in pairs(pMapnoNode:get_children()) do
        local iField = pNode:get_value()
        table.insert(rgiFields, iField)
    end

    return rgiFields
end

local function load_node_map_marker(pMapNode, tpHelperImages)
    local iRx
    local iRy
    iRx, iRy = pMapNode:get_spot()

    local iType = pMapNode:get_type()

    local sMarker = "mapImage/" .. iType
    local rgpQuads = tpHelperImages[sMarker]

    local pMarker = CWmapElemMark:new()
    pMarker:load(iRx, iRy, rgpQuads)

    return pMarker
end

function load_node_worldmap_map_list(pMapNode, tpHelperImages, tpPathImgs, sRegionName, iIdx)
    local rgiFields = load_node_mapno(pMapNode)
    local pPath = load_node_map_path(pMapNode, tpHelperImages, tpPathImgs, sRegionName, iIdx)
    local pTextbox = load_node_text_box(pMapNode)

    local pFieldMarker = load_node_map_marker(pMapNode, tpHelperImages)
    pFieldMarker:set_mapno(rgiFields)
    pFieldMarker:set_path(pPath)
    pFieldMarker:set_textbox(pTextbox)

    return pFieldMarker
end
