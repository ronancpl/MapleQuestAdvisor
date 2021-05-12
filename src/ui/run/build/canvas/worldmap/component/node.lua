--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("composer.field.node.image")
require("composer.field.node.spot")
require("composer.field.node.text_box")
require("ui.struct.canvas.worldmap.basic.image")
require("ui.struct.canvas.worldmap.basic.textbox")
require("ui.struct.canvas.worldmap.component.list.mapno")
require("ui.struct.canvas.worldmap.component.list.node")

local function load_xml_worldmap_node_path(pXmlWorldmapElement)
    local pXmlNode = pXmlWorldmapElement:get_child_by_name("path")

    local pImg = nil
    if pXmlNode ~= nil then
        local iOx
        local iOy
        local iZ
        iOx, iOy, iZ = load_xml_image(pXmlNode)

        pImg = CWmapBasicImage:new({iOx = iOx, iOy = iOy, iZ = iZ})
    end

    return pImg
end

local function load_xml_worldmap_node_mapno(pXmlWorldmapElement)
    local pNodeMapno = CWmapNodeMapno:new()

    local pXmlMapnoNode = pXmlWorldmapElement:get_child_by_name("mapNo")
    for _, pNode in pairs(pXmlMapnoNode:get_children()) do
        pNodeMapno:add(pNode)
    end

    return pNodeMapno
end

local function load_xml_worldmap_comp_textbox(pXmlWorldmapElement)
    local sTitle
    local sDesc
    sTitle, sDesc = load_xml_text_box(pXmlWorldmapElement)

    if sTitle then
        local pNodeTextbox = CWmapBasicTextbox:new({sTitle = sTitle, sDesc = sDesc})
        return pNodeTextbox
    else
        return nil
    end
end

local function load_xml_worldmap_comp_type(pXmlWorldmapElement)
    local pXmlNode = pXmlWorldmapElement:get_child_by_name("type")
    local iType = pXmlNode:get_value()
    return iType
end

local function load_xml_worldmap_comp_spot(pXmlWorldmapElement)
    local iOx
    local iOy
    iOx, iOy = load_xml_spot(pXmlWorldmapElement)

    return iOx, iOy
end

function load_xml_worldmap_node(pXmlWorldmapElement)
    local iNodeid = pXmlWorldmapElement:get_name_tonumber()

    local pImgPath = load_xml_worldmap_node_path(pXmlWorldmapElement)
    local pNodeMapno = load_xml_worldmap_node_mapno(pXmlWorldmapElement)
    local pNodeTextbox = load_xml_worldmap_comp_textbox(pXmlWorldmapElement)
    local siType = load_xml_worldmap_comp_type(pXmlWorldmapElement)
    local iOx, iOy = load_xml_worldmap_comp_spot(pXmlWorldmapElement)

    local pNodeMarker = CWmapNodeMarker:new({iOx = iOx, iOy = iOy})
    pNodeMarker:set_path(pImgPath)
    pNodeMarker:set_mapno(pNodeMapno)
    pNodeMarker:set_textbox(pNodeTextbox)
    pNodeMarker:set_type(siType)

    return iNodeid, pNodeMarker
end
