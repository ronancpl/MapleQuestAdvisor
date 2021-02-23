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
require("structs.field.worldmap.basic.textbox")
require("structs.field.worldmap.component.list.mapno")
require("structs.field.worldmap.component.list.node")

local function load_worldmap_node_path(pXmlWorldmapElement)
    local pXmlNode = pXmlWorldmapElement:get_child_by_name("path")
    return pXmlNode ~= nil and load_xml_image(pXmlNode) or nil
end

local function load_worldmap_node_mapno(pXmlWorldmapElement)
    local pNodeMapno = CWmapNodeMapno:new()

    local pXmlMapnoNode = pXmlWorldmapElement:get_child_by_name("mapNo")
    for _, pNode in pairs(pXmlMapnoNode:get_children()) do
        pNodeMapno:add(pNode)
    end

    return pNodeMapno
end

local function load_worldmap_comp_textbox(pXmlWorldmapElement)
    local sTitle
    local sDesc
    sTitle, sDesc = load_node_text_box(pXmlWorldmapElement)

    local pNodeTextbox = CWmapBasicTextbox:new(sTitle, sDesc)
    return pNodeTextbox
end

local function load_worldmap_comp_type(pXmlWorldmapElement)
    local pXmlNode = pXmlWorldmapElement:get_child_by_name("type")
    local iType = pXmlNode:get_value()
    return iType
end

local function load_worldmap_comp_spot(pXmlWorldmapElement)
    local iOx
    local iOy
    iOx, iOy = load_xml_spot(pXmlWorldmapElement)

    return iOx, iOy
end

function load_worldmap_node(pXmlWorldmapElement)
    local iNodeid = pXmlWorldmapElement:get_name_tonumber()

    local pImgPath = load_worldmap_node_path(pXmlWorldmapElement)
    local pNodeMapno = load_worldmap_node_mapno(pXmlWorldmapElement)
    local pNodeTextbox = load_worldmap_comp_textbox(pXmlWorldmapElement)
    local iType = load_worldmap_comp_type(pXmlWorldmapElement)
    local iOx, iOy = load_worldmap_comp_spot(pXmlWorldmapElement)

    local pWmapNode = CWmapNodeMarker:new(iOx, iOy)
    pWmapNode:set_path(pImgPath)
    pWmapNode:set_mapno(pNodeMapno)
    pWmapNode:set_textbox(pNodeTextbox)
    pWmapNode:set_type(iType)

    return iNodeid, pWmapNode
end
