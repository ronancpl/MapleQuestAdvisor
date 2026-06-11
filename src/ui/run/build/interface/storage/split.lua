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

local U_QUAD_SINGLE = -1

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

    local pImage = tQuads and tQuads[iIdx] or nil
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
        local pQuad = fetch_animation(tpQuads, sPath)

        local pImage = pQuad.get_image and pQuad:get_image() or pQuad
        insert_image(tpSlctImgs, sPath, U_QUAD_SINGLE, pImage)
    end

    local pDirSlctImgs = pDirMedia:clone()
    pDirSlctImgs:set_contents(tpSlctImgs)

    return pDirSlctImgs
end

local function intersect_image_subpath(pDirMedia, sPathImg)
    local sPrepend = pDirMedia:get_prepend()
    local rgsPath2 = split_pathd(pDirMedia:get_path() .. "/" .. sPrepend)
    local nPath = #rgsPath2

    if nPath > 0 then
        local rgsPath = split_pathd(sPathImg)
        local iPrepPathLen = #split_path(sPrepend)

        local nPath2 = #rgsPath

        local ii = 1
        local j = 1
        local jj = 0
        local kk = 0

        for k = 1, nPath, 1 do
            if rgsPath[ii] == rgsPath2[k] then
                jj = k

                for l = ii + 1, math.min(nPath2, nPath - jj + 1), 1 do
                    k = k + 1
                    if rgsPath[l] ~= rgsPath2[k] then
                        j = l
                        break
                    end
                end

                break
            elseif k == nPath then
                kk = nPath - iPrepPathLen
            end
        end

        local sPath
        if jj > 0 then
            sPath = rgsPath2[jj]
            for i = jj + 1, nPath, 1 do
                sPath = sPath .. "/" .. rgsPath2[j]
            end

            for j = j + 1, nPath2, 1 do
                sPath = sPath .. "." .. rgsPath[j]
            end
        else
            sPath = sPathImg
        end

        if sPrepend ~= "" then
            local iIdx = string.find(sPath, sPrepend)
            if iIdx then
                sPathImg = sPath:sub(iIdx + string.len(sPrepend) + 1)
            else
                sPathImg = sPath
            end
        end
    end

    return sPathImg
end

local function fetch_image_subpath_location(pDirMedia, sPathImg, bAnimation)
    -- relative pathing from pDirMedia
    local sBasepathImg = intersect_image_subpath(pDirMedia, sPathImg)
    return sBasepathImg
end

function find_image_on_storage(pDirMedia, sPathImg)
    local tpQuads = pDirMedia:get_contents()

    local sSubpathImg = fetch_image_subpath_location(pDirMedia, sPathImg, false)

    local pImgData = fetch_image(tpQuads, sSubpathImg, U_QUAD_SINGLE)
    return pImgData
end

function find_animation_on_storage(pDirMedia, sPathImg)
    local tpQuads = pDirMedia:get_contents()

    local sPath = fetch_image_subpath_location(pDirMedia, sPathImg, true)

    local rgpQuadDatum = fetch_animation(tpQuads, sPath)
    return rgpQuadDatum
end

function find_animation_image_on_storage(pDirMedia, sPathImg, iIdx)
    local rgpQuadDatum = find_animation_on_storage(pDirMedia, sPathImg)

    local rgpIdxQuadData = {}
    table.insert(rgpIdxQuadData, rgpQuadDatum[iIdx])

    return rgpIdxQuadData
end
