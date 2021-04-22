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

local function compose_param_values(rgpImgs, nCols)
    local iIx = 0
    local iIy = 0
    local iIw = U_INT_MIN
    local iIh = U_INT_MIN

    local iOx = 0
    local iOy = 0
    local iOw = U_INT_MIN
    local iOh = U_INT_MIN

    local nImgs = #rgpImgs
    local nRows = math.floor(nImgs / nCols)

    local iCurW = 0
    local iCurH = 0

    local i = 0
    local j = 0
    for _, pImgTxr in ipairs(rgpImgs) do
        i = (i + 1)
        iCurW = iCurW + pImgTxr:getWidth()

        if i >= nCols then
            i = i % nCols
            j = j + 1

            iOw = iCurW

            if j >= nRows then
                iOh = iCurH
            elseif j >= nRows - 1 then
                iIh = iCurH
            elseif j == 1 then
                iIy = iCurH
            end

            iCurW = 0
        elseif i >= nCols - 1 then
            iIw = iCurW
        elseif i == 1 then
            iIx = iCurW
            iCurH = iCurH + pImgTxr:getHeight()
        end
    end

    iOh = iCurH

    return iIx, iIy, iIw, iIh, iOx, iOy, iOw, iOh
end

local function merge_texture_image(rgpImgs, nCols, iWidth, iHeight)
    local i = 0
    local j = 0

    local pCanvas = love.graphics.newCanvas(iWidth, iHeight)

    local iPx = 0
    local iPy = 0

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

                iPx = 0
            elseif i == 1 then
                iPy = iPy + pImgTxr:getHeight()
            end
        end
    end)

    return pCanvas:newImageData(0, 0, iWidth, iHeight)
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
