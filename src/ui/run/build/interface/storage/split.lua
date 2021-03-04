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

local function fetch_image(tpQuads, sPath, iIdx)
    local tQuads = tpQuads[sPath]

    local pImage = tQuads[iIdx]
    return pImage
end

local function fetch_animation(tpQuads, sPath)
    local rgpQuads = tpQuads[sPath]
    return rgpQuads
end

local function select_all_if_empty(pDirMedia, rgsPaths)
    local rgsDirPaths = rgsPaths
    if #rgsDirPaths == 0 then
        local tpQuads = pDirMedia:get_contents()
        rgsDirPaths = keys(tpQuads)
    end

    return rgsDirPaths
end

function select_animations_from_storage(pDirMedia, rgsPaths)
    local tpSlctQuads = {}

    local rgsDirPaths = select_all_if_empty(pDirMedia, rgsPaths)
    local tpQuads = pDirMedia:get_contents()
    for _, sPath in ipairs(rgsDirPaths) do
        local rgpQuads = fetch_animation(tpQuads, sPath)
        insert_animation(tpSlctQuads, sPath, rgpQuads)
    end

    local pDirSlctQuads = pDirMedia:clone()
    pDirSlctQuads:set_contents(tpSlctQuads)

    return pDirSlctQuads
end

function select_images_from_storage(pDirMedia, rgsPaths)
    local tpSlctImgs = {}

    local rgsDirPaths = select_all_if_empty(pDirMedia, rgsPaths)
    local tpQuads = pDirMedia:get_contents()

    for _, sPath in ipairs(rgsDirPaths) do
        local rgpQuads = fetch_animation(tpQuads, sPath)

        for iIdx, pQuad in ipairs(rgpQuads) do
            local iPosIdx = iIdx

            local pImage = pQuad.get_image and pQuad:get_image() or pQuad
            insert_image(tpSlctImgs, sPath, iPosIdx, pImage)
        end
    end

    local pDirSlctImgs = pDirMedia:clone()
    pDirSlctImgs:set_contents(tpSlctImgs)

    return pDirSlctImgs
end

local function intersect_image_subpath(pDirMedia, sPathImg)
    local sPath = pDirMedia:get_path()

    local iIdx = sPathImg:find(sPath)
    if iIdx ~= nil then
        local iStIdx = iIdx + string.len(sPath) + 1

        local sSubpathImg = sPathImg:sub(iStIdx)
        return 0, sSubpathImg
    else
        return 0, sPathImg
    end
end

local function fetch_image_subpath_index(bAnimation, rgsPath, nPath, sSubpathImg)
    local iIdx

    if bAnimation then
        return nPath    -- whole path already processed from image directory
    else
        for iIdx = nPath, 1, -1 do
            local sPath = rgsPath[iIdx]

            if tonumber(sPath) ~= nil then
                local iTopIdx = iIdx - 1
                return iTopIdx
            end
        end

        return -1
    end
end

local function fetch_image_subpath_location(pDirMedia, sPathImg, bAnimation)
    -- relative pathing from pDirMedia
    local iBaseIdx
    local sSubpathImg
    iBaseIdx, sSubpathImg = intersect_image_subpath(pDirMedia, sPathImg)
    iBaseIdx = iBaseIdx + 1

    local rgsPath = split_pathd(sSubpathImg)

    local nPath = #rgsPath
    local iTopIdx = fetch_image_subpath_index(bAnimation, rgsPath, nPath, sSubpathImg)

    local rgsSubpath = slice(rgsPath, iBaseIdx, iTopIdx)
    local sSubpathImg = table.concat(rgsSubpath,".")

    return iTopIdx, sSubpathImg
end

function find_image_on_storage(pDirMedia, sPathImg)
    local tpQuads = pDirMedia:get_contents()

    local iIdx
    local sSubpathImg
    iIdx, sSubpathImg = fetch_image_subpath_location(pDirMedia, sPathImg, false)

    local pImg = fetch_image(tpQuads, sSubpathImg, iIdx)
    return pImg
end

function find_animation_on_storage(pDirMedia, sPathImg)
    local tpQuads = pDirMedia:get_contents()

    local iIdx
    local sPath
    iIdx, sPath = fetch_image_subpath_location(pDirMedia, sPathImg, true)

    local rgpQuads = fetch_animation(tpQuads, sPath)
    return rgpQuads
end
