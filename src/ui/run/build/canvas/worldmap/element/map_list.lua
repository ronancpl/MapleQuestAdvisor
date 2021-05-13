--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("ui.constant.path")
require("ui.run.build.interface.storage.split")
require("ui.run.load.graphic.text_box")
require("ui.struct.canvas.worldmap.basic.sprite")
require("ui.struct.canvas.worldmap.element.path")
require("utils.procedure.copy")

local function load_node_map_path(pWmapProp, pMapNode, pDirWmapImgs, sRegionName, iIdx)
    local sXmlPath = RWndPath.WMAP_DIR .. "/" .. sRegionName .. "/MapList/" .. iIdx .. "/path"

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
    pPath:load(pWmapProp, pImg, iOx, iOy, iZ, 0, 0)

    return pPath
end

local function load_node_mapno(pMapNode)
    local pNodeMapno = pMapNode:get_mapno()

    local rgiFields = {}
    for _, pNode in ipairs(pNodeMapno:list()) do
        local iIdx = pNode:get_name_tonumber() + 1
        local iField = pNode:get_value()

        rgiFields[iIdx] = iField
    end

    return rgiFields
end

local function load_map_marker_quads(pDirHelperQuads, iType)
    local sPathImg = "npcPos" .. iType
    local rgpQuads = find_animation_on_storage(pDirHelperQuads, sPathImg)

    return rgpQuads
end

function load_quad_map_marker(pMarker, pWmapProp, pDirHelperQuads)
    local iType = pMarker:get_type()
    local rgpQuads = load_map_marker_quads(pDirHelperQuads, iType)

    pMarker:reload_quad(rgpQuads, pWmapProp)
end

local function load_node_map_marker(pWmapProp, pMapNode, pDirHelperQuads)
    local iRx
    local iRy
    iRx, iRy = pMapNode:get_spot()

    local pMarker = CWmapElemMark:new()
    pMarker:load(iRx, iRy, pMapNode:get_type(), pWmapProp)
    load_quad_map_marker(pMarker, pWmapProp, pDirHelperQuads)

    return pMarker
end

local function load_mapno_text_box(rgiFields)
    local sMapName
    if #rgiFields > 0 then
        sMapName = ctFieldsMeta:get_street_name(rgiFields[1])
    else
        sMapName = ""
    end

    local pTextbox = CWmapBasicTextbox:new({sTitle = "", sDesc = sMapName})
    return pTextbox
end

local function load_node_map_textbox(pMapNode, rgiFields)
    local pMapTextbox = pMapNode:get_textbox()
    if pMapTextbox == nil then
        pMapTextbox = load_mapno_text_box(rgiFields)
    end

    local pTextbox = load_node_text_box(pMapTextbox)
    return pTextbox
end

function load_node_worldmap_map_list(pWmapProp, pMapNode, pDirHelperQuads, pDirWmapImgs, sRegionName, iIdx)
    local rgiFields = load_node_mapno(pMapNode)
    local pPath = load_node_map_path(pWmapProp, pMapNode, pDirWmapImgs, sRegionName, iIdx)
    local pTextbox = load_node_map_textbox(pMapNode, rgiFields)

    local pFieldMarker = load_node_map_marker(pWmapProp, pMapNode, pDirHelperQuads)
    pFieldMarker:set_mapno(rgiFields)
    pFieldMarker:set_path(pPath)
    pFieldMarker:set_textbox(pTextbox)

    return pFieldMarker
end
