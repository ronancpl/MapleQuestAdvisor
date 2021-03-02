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
require("ui.run.build.interface.storage.split")
require("ui.run.load.graphic.text_box")
require("ui.struct.worldmap.basic.sprite")
require("ui.struct.worldmap.element.path")
require("utils.procedure.copy")

local function load_node_map_path(pMapNode, pDirWmapImgs, sRegionName, iIdx)
    local sXmlPath = RInterface.WMAP_DIR .. "/" .. sRegionName .. "/MapList/" .. iIdx .. "/path"

    local pImg = find_image_on_storage(pDirWmapImgs, sXmlPath)
    if pImg == nil then     -- empty content
        return nil
    end

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
    local rgiFields = pMapNode:get_mapno()
    return deep_copy(rgiFields)
end

local function load_node_map_marker(pMapNode, pDirHelperImgs)
    local iRx
    local iRy
    iRx, iRy = pMapNode:get_spot()

    local iType = pMapNode:get_type()

    local sMarker = "mapImage/" .. iType
    local rgpQuads = find_animation_on_storage(pDirHelperImgs, sMarker)

    local pMarker = CWmapElemMark:new()
    pMarker:load(iRx, iRy, rgpQuads)

    return pMarker
end

local function load_node_map_textbox(pMapNode)
    local pMapTextbox = pMapNode:get_textbox()

    local pTextbox = load_node_text_box(pMapTextbox)
    return pTextbox
end

function load_node_worldmap_map_list(pMapNode, pDirHelperImgs, pDirWmapImgs, sRegionName, iIdx)
    local rgiFields = load_node_mapno(pMapNode)
    local pPath = load_node_map_path(pMapNode, pDirWmapImgs, sRegionName, iIdx)
    local pTextbox = load_node_map_textbox(pMapNode)

    local pFieldMarker = load_node_map_marker(pMapNode, pDirHelperImgs)
    pFieldMarker:set_mapno(rgiFields)
    pFieldMarker:set_path(pPath)
    pFieldMarker:set_textbox(pTextbox)

    return pFieldMarker
end
