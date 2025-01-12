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
require("composer.field.node.media.storage.storage")
require("utils.procedure.string")
require("utils.procedure.unpack")

local function load_quad_img_set(tpImgs, sPrepend)
    sPrepend = sPrepend:gsub("/", ".")

    local tpQuads = {}
    for sPath, pImg in pairs(tpImgs) do
        local sImgPath = sPath
        if string.starts_with(sImgPath, sPrepend .. "%.") then
            while true do
                local iIdx = string.rfind(sImgPath, ".%")
                if iIdx ~= nil then
                    local sQuadPath = sImgPath:sub(1,iIdx-1)
                    local sSprite = sImgPath:sub(iIdx+1, -1)

                    local iSprite = tonumber(sSprite, 10)
                    if iSprite ~= nil then    -- is integer
                        local tQuad = create_inner_table_if_not_exists(tpQuads, sQuadPath)
                        tQuad[iSprite] = pImg
                        break
                    end

                    sImgPath = sImgPath:sub(1, iIdx - 1)
                else
                    break
                end
            end
        end
    end

    return tpQuads
end

local function array_quad_image_sets(tQuads)
    local tpQuads = {}
    for sKey, tpImgs in pairs(tQuads) do
        local rgpImgs = {}

        local i = 0
        while true do
            local iSprite = i
            local pImg = tpImgs[iSprite]
            if pImg == nil then
                break
            end

            table.insert(rgpImgs, pImg)

            i = i + 1
        end

        tpQuads[sKey] = rgpImgs
    end

    return tpQuads
end

function load_quads_from_path(sImgPath, sDirPath)
    local pDirImgs = load_images_from_path(sImgPath)
    local tpImgs = pDirImgs:get_contents()

    local tpQuads = load_quad_img_set(tpImgs, sDirPath)
    tpQuads = array_quad_image_sets(tpQuads)

    local pDirQuads = CMediaTable:new()
    pDirQuads:set_path(sImgPath)
    pDirQuads:set_contents(tpQuads)

    return pDirQuads
end
