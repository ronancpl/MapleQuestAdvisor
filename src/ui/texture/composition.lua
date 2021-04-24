--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("router.procedures.constant")

local function get_num_rows(rgpImgs, nCols)
    local nImgs = #rgpImgs
    return math.floor(nImgs / nCols)
end

local function calc_texture_image_params(rgpImgs, nCols)
    local iIx = 0
    local iIy = 0
    local iIw = U_INT_MIN
    local iIh = U_INT_MIN

    local iOx = 0
    local iOy = 0
    local iOw = U_INT_MIN
    local iOh = U_INT_MIN

    local nRows = get_num_rows(rgpImgs, nCols)

    local iCurW = 0
    local iCurH = 0

    local i = 0
    local j = 0
    for _, pImgTxr in ipairs(rgpImgs) do
        local iImgW = pImgTxr:getWidth()

        i = (i + 1)
        iCurW = iCurW + iImgW

        if i == 1 then
            iIx = iCurW
        end

        if i >= nCols then
            i = i % nCols
            j = j + 1

            iOw = iCurW
            iCurW = 0

            local iImgH = pImgTxr:getHeight()
            iCurH = iCurH + iImgH

            if j == 1 then
                iIy = iImgH
            end

            if j >= nRows then
                iOh = iCurH
            elseif j >= nRows - 1 then
                iIh = iCurH - iIy
            end
        elseif i >= nCols - 1 then
            iIw = iCurW - iIx
        end
    end

    iOh = iCurH

    return iIx, iIy, iIw, iIh, iOx, iOy, iOw, iOh
end

local function normalize_textureset_params(rgpImgs, nCols, iIx, iIy, iIw, iIh, iOx, iOy, iOw, iOh)
    local nRows = get_num_rows(rgpImgs, nCols)

    -- summarize parameters having insufficient entries with generic inner-box
    if nRows < 3 then
        iIy = 15
        iIh = iOh - (2 * 15)
    end

    if nCols < 3 then
        iIx = 15
        iIw = iOw - (2 * 15)
    end

    return iIx, iIy, iIw, iIh
end

local function compose_param_values(rgpImgs, nCols)
    local iIx, iIy, iIw, iIh, iOx, iOy, iOw, iOh = calc_texture_image_params(rgpImgs, nCols)
    iIx, iIy, iIw, iIh = normalize_textureset_params(rgpImgs, nCols, iIx, iIy, iIw, iIh, iOx, iOy, iOw, iOh)

    return iIx, iIy, iIw, iIh, iOx, iOy, iOw, iOh
end

local function merge_texture_image(rgpImgs, nCols, iWidth, iHeight)
    local i = 0
    local j = 0

    local pCanvas = love.graphics.newCanvas(iWidth, iHeight)

    local iPx = 0
    local iPy = 0

    local iTw
    local iTh

    pCanvas:renderTo(function()
        love.graphics.clear()

        for _, pImgTxr in ipairs(rgpImgs) do

            -- compose textures by drawing onto canvas, inner and outer values generated from images width/height
            love.graphics.draw(pImgTxr, iPx, iPy)

            i = (i + 1)
            iPx = iPx + pImgTxr:getWidth()

            if i >= nCols then
                i = i % nCols
                j = j + 1

                iTw = iPx
                iPx = 0

                iPy = iPy + pImgTxr:getHeight()
            end
        end
    end)

    iTh = iPy

    local pImgData = pCanvas:newImageData(0, 1, 0, 0, iTw, iTh)
    return love.graphics.newImage(pImgData)
end

function compose_texture_from_imageset(rgpImgs, nCols)
    --[[
        Image set should have same:
            * Width - share rows
            * Height - share columns
    ]]--

    local iIx, iIy, iIw, iIh, iOx, iOy, iOw, iOh = compose_param_values(rgpImgs, nCols)
    local pImg = merge_texture_image(rgpImgs, nCols, iOw, iOh)

    return pImg, iIx, iIy, iIw, iIh, iOx, iOy, iOw, iOh
end
