--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("ui.run.load.graphic.quad")
require("utils.procedure.unpack")
require("utils.provider.io.wordlist")
require("utils.provider.xml.provider")

local function store_animation(tpWmapHelperAnims, sPos, rgpQuads)
    local rgsPath = split_path(sPos)
    local nPath = #rgsPath

    local tQuads = tpWmapHelperAnims
    for i = 1, nPath - 1, 1 do
        local sName = rgsPath[i]
        tQuads = create_inner_table_if_not_exists(tQuads, sName)
    end

    tQuads[rgsPath[nPath]] = rgpQuads
    return tQuads
end

local function store_image(tpWmapHelperAnims, sPos, iIdx, pImage)
    local rgsPath = split_path(sPos)

    local tQuads = tpWmapHelperAnims
    for _, sName in ipairs(rgsPath) do
        tQuads = create_inner_table_if_not_exists(tQuads, sName)
    end

    tQuads[iIdx] = pImage
    return tQuads
end

local function fetch_animation(tpWmapHelperQuads, sPos)
    local tpQuads = tpWmapHelperQuads

    local rgsPath = split_path(sPos)
    for _, sName in ipairs(rgsPath) do
        tpQuads = tpQuads[sName]
    end

    local rgpQuads = tpQuads
    return rgpQuads
end

local function load_animations_position_helper(tpWmapHelperQuads)
    local tpWmapHelperAnims = {}

    local rgsPos = {"curPos", "lovePos", "npcPos/0", "npcPos/1", "npcPos/2", "npcPos/3", "partyPos"}
    for _, sPos in ipairs(rgsPos) do
        local sImgPos = sPos:gsub("/", "")
        local rgpQuads = fetch_animation(tpWmapHelperQuads, sImgPos)
        store_animation(tpWmapHelperAnims, sPos, rgpQuads)
    end

    return tpWmapHelperAnims
end

local function load_images_position_helper(tpWmapHelperQuads)
    local tpWmapHelperImgs = {}

    local rgsPos = {"mapImage"}
    for _, sPos in ipairs(rgsPos) do
        local rgpQuads = fetch_animation(tpWmapHelperQuads, sPos)

        for iIdx, pQuad in ipairs(rgpQuads) do
            local iPosIdx = iIdx - 1

            local pImage = pQuad:get_image()
            store_image(tpWmapHelperImgs, sPos, iPosIdx, pImage)
        end
    end

    return tpWmapHelperImgs
end

function load_frame_position_helper()
    local sWmapNodePath = RInterface.WMAP_HELPER
    local sWmapImgPath = "images/" .. sWmapNodePath

    local tpHelperQuads = load_quads_from_wz_sub(sWmapImgPath)
    local tpWmapHelperQuads = load_animations_position_helper(tpHelperQuads)
    local tpWmapHelperImages = load_images_position_helper(tpHelperQuads)

    return tpWmapHelperQuads, tpWmapHelperImages
end
