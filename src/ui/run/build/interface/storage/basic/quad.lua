--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("composer.field.node.media.image")
require("composer.field.node.media.quad")
require("ui.path.path")
require("ui.run.build.graphic.quad")
require("ui.run.build.xml.directory")
require("utils.procedure.string")
require("utils.provider.io.wordlist")
require("utils.provider.xml.provider")

local function is_path_img_node(tpImgs)
    return tpImgs["img"] ~= nil
end

local function is_path_quad_node(tpImgs)
    local tpSub = next(tpImgs)
    return tpSub ~= nil and is_path_img_node(tpImgs)
end

local function fetch_quad_xml_node(pXmlBase, sPath)
    local pXmlNode = pXmlBase

    local rgsPath = split_path(sPath)

    local st = ""
    for _, sName in ipairs(rgsPath) do
        st = st .. sName .. ", "
    end
    log_st(LPath.INTERFACE, "_locator.txt", ">>>> '" .. st .. "'")

    for _, sName in ipairs(rgsPath) do
        pXmlNode = pXmlNode:get_child_by_name(sName)
    end

    return pXmlNode
end

local function load_quad_img_set(pXmlQuadSub, rgpImgs)
    local rgpQuads = {}

    for iIdx, pImg in ipairs(rgpImgs) do
        local sIdx = "" .. (iIdx - 1)
        local pXmlQuad = pXmlQuadSub:get_child(sIdx)

        local pSpriteNode = load_xml_sprite(pXmlQuad)

        local pQuad = load_node_quad(pSpriteNode, pImg)
        table.insert(rgpQuads, pQuad)
    end

    return rgpQuads
end

local function load_quad_img_sets_from_path(pXmlBase, tpQuads)
    local tpPathQuad = {}

    for sPath, rgpImgs in pairs(tpQuads) do
        log_st(LPath.INTERFACE, "result.txt", "SETQD '" .. sPath .. "'")

        local pXmlQuad = fetch_quad_xml_node(pXmlBase, sPath)
        local rgpQuads = load_quad_img_set(pXmlQuad, rgpImgs)

        tpPathQuad[sPath] = rgpQuads
        log_st(LPath.INTERFACE, "_quad.txt", "SETQD '" .. sPath .. "' " .. #rgpQuads)
    end

    return tpPathQuad
end

local function load_quad_img_sets_from_directory(sImgPath, sDirPath)
    local tpQuads = load_quads_from_path(RInterface.LOVE_IMAGE_DIR_PATH .. sImgPath .. "/" .. sDirPath)

    log_st(LPath.INTERFACE, "_locator.txt", " HAVING '" .. sImgPath .. "' '" .. sDirPath .. "'")
    local pXmlNode = load_xml_node_from_directory(sImgPath, sDirPath)

    local tpPathQuad = load_quad_img_sets_from_path(pXmlNode, tpQuads)
    return tpPathQuad
end

function load_quad_storage_from_wz_sub(sImgPath, sDirPath)
    local tpPathQuad = load_quad_img_sets_from_directory(sImgPath, sDirPath)
    return tpPathQuad
end
