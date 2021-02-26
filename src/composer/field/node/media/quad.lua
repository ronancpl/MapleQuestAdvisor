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

local function load_quad_img_set(pXmlQuad, tpImgs)
    local tpQuads = {}
    for sImgPath, pImg in pairs(tpImgs) do
        local iIdx = string.rfind(sImgPath, "/")
        if iIdx > 0 then
            local sQuadPath = sImgPath:sub(1:iIdx-1)
            local sSprite = sImgPath:sub(iIdx+1:-1)

            if tonumber(sSprite, 10) ~= nil then    -- is integer
                local tQuad = create_inner_table_if_not_exists(tpQuads, sQuadPath)
                tQuad[sSprite] = pImg
            end
        end
    end

    return tpQuads
end

function load_quads_from_path(tpImgs)
    local tpQuads = load_quad_img_set(pXmlQuad, tpImgs)
    return tpQuads
end

function fetch_quad_from_container(tpQuads, sPath)
    return tpQuads[sPath]
end
