--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("utils.provider.io.wordlist")

local function load_images_from_directory(sDirPath)
    local tpImgs = {}

    local rgsFiles = love.filesystem.getDirectoryItems(sDirPath)
    for _, sFileName in ipairs(rgsFiles) do
        local tImgPath = tpImgs

        local rgsText = split_text(sText)
        local nText = #rgsText
        if nText > 0 then
            for i = 1, nText - 1, 1 do
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

local function load_quad_img_set(pXmlQuad, rgsPath, tpImgs)
    local sPath = table.concat(rgsPath, ".")

    for sSprite, pImg in pairs(tpImgs) do
        local pXmlSpriteNode = pXmlQuad:get_child_by_name(sSprite)

        local pDelay = pXmlSpriteNode:get_child_by_name("delay")

        local pOrig = pXmlSpriteNode:get_child_by_name("origin")
        local iX = tonumber(pOrig:get("x"))
        local iY = tonumber(pOrig:get("y"))

        local iZ = pXmlSpriteNode:get_child_by_name("z")

    end
end

function load_quad_img_sets_from_path(tpPathQuad, rgsPath, tpImgs)
    if is_path_quad_node(tpImgs) then
        load_quad_img_set(rgsPath, tpImgs)
    else
        for sKey, tpSub in pairs(tpImgs) do
            table.insert(rgsPath, sKey)
            load_quad_img_sets_from_path(tpSub)
            table.remove(rgsPath)
        end
    end
end

function load_quad_img_sets_from_directory(sDirPath)
    local tpImgs = load_images_from_directory(sDirPath)

    local tpPathQuad = {}
    load_quad_img_sets_from_path(tpPathQuad, {}, tpImgs)

    return tpPathQuad
end

