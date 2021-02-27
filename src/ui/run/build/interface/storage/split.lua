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

function select_animations_from_storage(tpQuads, rgsPaths)
    local tpSlctQuads = {}

    local st = ""
    for sName, _ in pairs(tpQuads) do
        st = st .. sName .. ", "
    end
    log_st(LPath.INTERFACE, "_quads.txt", ">>>> '" .. st .. "' ")

    for _, sPath in ipairs(rgsPaths) do
        local rgpQuads = fetch_animation(tpQuads, sPath)
        log_st(LPath.INTERFACE, "_anim.txt", ">>>> '" .. sPath .. "' " .. #rgpQuads)

        insert_animation(tpSlctQuads, sPath, rgpQuads)
    end

    return tpSlctQuads
end

function select_images_from_storage(tpQuads, rgsPaths)
    local tpSlctImgs = {}

    for _, sPath in ipairs(rgsPaths) do
        local rgpQuads = fetch_animation(tpQuads, sPath)
        log_st(LPath.INTERFACE, "_anim.txt", "<<<< '" .. sPath .. "' " .. #rgpQuads)

        for iIdx, pQuad in ipairs(rgpQuads) do
            local iPosIdx = iIdx - 1

            local pImage = pQuad:get_image()
            insert_image(tpSlctImgs, sPath, iPosIdx, pImage)
        end
    end

    return tpSlctImgs
end

function find_image_on_storage(tpQuads, sPathImg)
    local pImg = nil

    local i = string.rfind(sPathImg, "/")
    if i ~= nil then
        local sPath = sPathImg:sub(1, i-1)
        local iIdx = tonumber(sPathImg:sub(i+1, -1))

        pImg = find_image(tpQuads, sPath, iIdx)
    end

    return pImg
end

function find_animation_on_storage(tpQuads, sPathImg)
    return fetch_animation(tpQuads, sPathImg)
end
