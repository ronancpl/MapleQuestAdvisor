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
require("ui.struct.worldmap.element.path")

local function load_xml_map_path(pXmlMapNode)
    local pXmlPathNode = pXmlMapNode:get_child_by_name("path")

    local sXmlPath = RInterface.WMAP_MARKER .. "/" .. iType
    local pImg = fetch_image_from_container(tpPathImgs, sXmlPath)   -- get marker image

    local iOx
    local iOy
    local iZ
    local iOx, iOy, iZ = load_xml_image(pXmlPathNode)

    local pPath = CWmapElemPath:new()
    pFieldNode:load(pImg, iOx, iOy, iZ, 0, 0)

    return pPath
end

local function load_xml_mapno(pXmlMapNode)
    local rgiFields = {}

    local pXmlPathNode = pXmlMapNode:get_child_by_name("mapNo")
    for _, pNode in ipairs(pXmlPathNode:get_children()) do
        local iField = pNode:get_value()
        table.insert(rgiFields, iField)
    end

    return rgiFields
end

local function load_xml_map_marker(pXmlMapNode, tpPathImgs)
    local iRx
    local iRy
    iRx, iRy = load_xml_spot(pXmlMapNode)

    local iType = pXmlMapNode:get_child_by_name("type"):get_value()
    local sXmlPath = RInterface.WMAP_MARKER .. "/" .. iType
    local pImg = fetch_image_from_container(tpPathImgs, sXmlPath)   -- get marker image

    local iOx
    local iOy
    local iZ
    iOx, iOy, iZ = load_xml_image(pXmlImgNode)

    return pImg, iOx, iOy, iZ, iRx, iRy
end

function load_xml_worldmap_map_list(pXmlMapLink, tpPathImgs)
    local rgiFields = load_xml_mapno(pXmlMapNode)

    local pPath = load_xml_map_path(pXmlMapNode)

    local sTitle
    local sDesc
    sTitle, sDesc = load_xml_text_box(pXmlMapNode)

    local iRx
    local iRy
    local iOx
    local iOy
    local iZ
    local pImg
    pImg, iOx, iOy, iZ, iRx, iRy = load_xml_map_marker(pXmlMapNode)

    local pFieldMarker = CWmapElemMark:new()
    pFieldMarker:load(pImg, iOx, iOy, iZ, iRx, iRy)

    pFieldMarker:set_mapno(rgiFields)
    pFieldMarker:set_path(pPath)
    pFieldMarker:set_textbox(pTextbox)

    return pFieldMarker
end
