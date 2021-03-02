--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("utils.procedure.string")
require("utils.procedure.unpack")

local function insert_animation(tQuads, sPath, rgpQuads)
    tQuads[sPath] = rgpQuads
end

local function insert_image(tQuads, sPath, iIdx, pImage)
    local tpQuads = tQuads

    tpQuads = create_inner_table_if_not_exists(tpQuads, sPath)
    tpQuads[iIdx] = pImage

    return tpQuads
end

local function find_image(tQuads, sPath, iIdx)
    local tpQuads = tQuads[sPath]

    local pImage = tpQuads ~= nil and tpQuads[iIdx] or nil
    return pImage
end

local function fetch_animation(tpQuads, sPath)
    local rgpQuads = tpQuads[sPath]
    return rgpQuads
end

function select_animations_from_storage(pDirMedia, rgsPaths)
    local tpSlctQuads = {}

    local tpQuads = pDirMedia:get_contents()
    for _, sPath in ipairs(rgsPaths) do
        local rgpQuads = fetch_animation(tpQuads, sPath)
        insert_animation(tpSlctQuads, sPath, rgpQuads)
    end

    return tpSlctQuads
end

function select_images_from_storage(pDirMedia, rgsPaths)
    local tpSlctImgs = {}

    local tpQuads = pDirMedia:get_contents()
    for _, sPath in ipairs(rgsPaths) do
        local rgpQuads = fetch_animation(tpQuads, sPath)

        for iIdx, pQuad in ipairs(rgpQuads) do
            local iPosIdx = iIdx - 1

            local pImage = pQuad:get_image()
            insert_image(tpSlctImgs, sPath, iPosIdx, pImage)
        end
    end

    return tpSlctImgs
end

local function fetch_image_subpath_location(pDirMedia, sPathImg)
    -- relative pathing from pDirMedia
    local rgsDirPath = split_path(pDirMedia:get_path())
    local iBaseIdx = #rgsDirPath + 1

    local rgsPath = split_path(sPathImg)

    local iIdx = nil
    for i = #rgsPath, iBaseIdx, -1 do
        local sPath = rgsPath[i]

        local iIdx = tonumber(sPath)
        if iIdx ~= nil then
            local rgsSubpath = slice(rgsPath, iBaseIdx, iIdx)
            local sSubpathImg = table.concat(rgsSubpath,".")

            return iIdx, sSubpathImg
        end
    end

    return -1, sPathImg
end

local function fetch_image_subpath(pDirMedia, sPathImg)
    local iIdx
    local sSubpathImg
    iIdx, sSubpathImg = fetch_image_subpath_location(pDirMedia, sPathImg)

    return sSubpathImg, iIdx
end

function find_image_on_storage(pDirMedia, sPathImg)
    local pImg = nil

    local tpQuads = pDirMedia:get_contents()

    local sSubpathImg
    local iIdx
    sSubpathImg, iIdx = fetch_image_subpath(pDirMedia, sPathImg)

    local pImg = find_image(tpQuads, sSubpathImg, iIdx)
    return pImg
end

--[[
function find_animation_on_storage(tpQuads, sPathImg)
    return fetch_animation(tpQuads, sPathImg)
end
]]--
