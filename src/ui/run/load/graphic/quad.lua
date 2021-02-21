--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("composer.field.node.quad")
require("composer.field.node.media.image")
require("ui.run.xml.directory")
require("utils.procedure.string")
require("utils.provider.io.wordlist")
require("utils.provider.xml.provider")

local function is_path_img_node(tpImgs)
    return tpImgs["img"] ~= nil
end

local function is_path_quad_node(tpImgs)
    local tpSub = next(tpImgs)
    return tpSub ~= nil and is_path_img_node(tpSub)
end

local function fetch_quad_xml_node(pXmlRoot, rgsPath)
    local pXmlNode = pXmlRoot
    for _, sName in ipairs(rgsPath) do
        pXmlNode = pXmlNode:get_child_by_name(sName)
    end

    return pXmlNode
end

local function load_quad_img_set(pXmlQuad, tpImgs)
    local tpQuads = {}
    for sSprite, pImg in pairs(tpImgs) do
        local pXmlSpriteNode = pXmlQuad:get_child_by_name(sSprite)
        tpQuads[sSprite] = load_quad(pXmlSpriteNode, pImg)
    end

    local rgpQuads = {}

    local i = 0
    while true do
        local sIter = "" .. i
        local pQuad = tpQuads[sIter]

        if pQuad == nil then
            break
        end

        table.insert(rgpQuads, pQuad)
        i = i + 1
    end

    return rgpQuads
end

local function load_quad_img_sets_from_path(pXmlRoot, tpPathQuad, rgsPath, tpImgs)
    if is_path_quad_node(tpImgs) then   -- quad set (aka sprite) index locates at last position in path
        local sPath = table.concat(rgsPath, ".")

        local pXmlQuad = fetch_quad_xml_node(pXmlRoot, rgsPath)
        local rgpQuads = load_quad_img_set(pXmlQuad, tpImgs)

        tpPathQuad[sPath] = rgpQuads
    else
        for sKey, tpSub in pairs(tpImgs) do
            table.insert(rgsPath, sKey)
            load_quad_img_sets_from_path(pXmlRoot, tpPathQuad, rgsPath, tpSub)
            table.remove(rgsPath)
        end
    end
end

local function load_quad_img_sets_from_directory(sDirPath)
    local tpImgs = load_images_from_directory(sDirPath)
    local pXmlRoot = load_xml_node_from_directory(sDirPath)

    local tpPathQuad = {}
    load_quad_img_sets_from_path(pXmlRoot, tpPathQuad, {}, tpImgs)

    return tpPathQuad
end

function load_quads_from_wz_sub(sDirPath)
    local tpPathQuad = load_quad_img_sets_from_directory(sDirPath)
    return tpPathQuad
end
