--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("ui.struct.component.basic.quad")
require("utils.procedure.string")
require("utils.provider.io.wordlist")
require("utils.provider.xml.provider")

local function load_images_from_directory(sDirPath)
    local tpImgs = {}

    local rgsFiles = love.filesystem.getDirectoryItems(sDirPath)
    for _, sFileName in ipairs(rgsFiles) do
        local tImgPath = tpImgs

        local rgsText = split_text(sText)
        local nText = #rgsText
        if nText > 0 then
            for i = 1, nText - 1, 1 do  -- minus file extension
                tImgPath = create_inner_table_if_not_exists(tImgPath, rgsText[i])
            end

            local pImg = love.graphics.newImage(sDirPath .. sFileName)
            tImgPath["img"] = pImg
        end
    end

    return tpImgs
end

local function is_path_img_node(tpImgs)
    return tpImgs["img"] ~= nil
end

local function is_path_quad_node(tpImgs)
    local tpSub = next(tpImgs)
    return tpSub ~= nil and is_path_img_node(tpSub)
end

local function load_quad_img_set(pXmlQuad, tpImgs)
    local tpQuads = {}
    for sSprite, pImg in pairs(tpImgs) do
        local pXmlSpriteNode = pXmlQuad:get_child_by_name(sSprite)

        local iDelay = pXmlSpriteNode:get_child_by_name("delay")

        local pOrig = pXmlSpriteNode:get_child_by_name("origin")
        local iX = tonumber(pOrig:get("x"))
        local iY = tonumber(pOrig:get("y"))

        local iZ = pXmlSpriteNode:get_child_by_name("z")

        tpQuads[sSprite] = CBasicQuad:new()
        tpQuads[sSprite]:load(pImg, iX, iY, iZ, iDelay)
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

local function fetch_quad_xml_node(pXmlRoot, rgsPath)
    local pXmlNode = pXmlRoot
    for _, sName in ipairs(rgsPath) do
        pXmlNode = pXmlNode:get_child_by_name(sName)
    end

    return pXmlNode
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

local function load_xml_node_from_directory(sDirPath)
    local sImgXmlPath
    local sImgDirNodePath

    local i = string.find(sDirPath, ".img")
    sImgXmlPath = string.sub(sDirPath, 1, i)
    sImgDirNodePath = string.sub(sDirPath, i + 4, -1)

    local pImgXmlNode = SXmlProvider:load_xml(sImgXmlPath)
    local rgsSubNames = split_text(sImgDirNodePath)

    local pXmlNode = pImgXmlNode
    for _, sName in ipairs(rgsSubNames) do
        pXmlNode = pXmlNode:get_child_by_name(sName)
    end

    return pXmlNode
end

function load_quad_img_sets_from_directory(sDirPath)
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
