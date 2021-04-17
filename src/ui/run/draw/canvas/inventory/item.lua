--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("ui.constant.view.inventory")
require("ui.struct.toolkit.color")
require("ui.struct.toolkit.graphics")

local function calc_count_dimensions(rgpImgNums)
    local iAccW = 0
    local iH = 0
    for _, pImg in ipairs(rgpImgNums) do
        local iW
        iW, iH = pImg:getDimensions()

        iAccW = iAccW + iW
    end

    return iAccW, iH
end

local function draw_item_count(iCount, iPx, iPy, iWidth, iHeight, siType)
    if iCount ~= nil then
        local rgpImgNums = ctVwInvt:get_images_by_number(iCount)

        local iAccW, iH = calc_count_dimensions(rgpImgNums)  -- count position at RB
        local iX = iPx + iWidth - iAccW
        local iY = iPy + iHeight - iH

        for _, pImgNum in ipairs(rgpImgNums) do
            love.graphics.draw(pImgNum, iX, iY)

            local iW
            iW, _ = pImgNum:getDimensions()

            iX = iX + iW
        end
    end
end

local function draw_item_tile(pImgItem, iPx, iPy, iCnvWidth, iCnvHeight, siType)
    local pVwCnv = CViewCanvas:new()
    pVwCnv:load(iCnvWidth, iCnvHeight)

    pVwCnv:render_to(function()
        love.graphics.clear()
        draw_canvas_item_tile(pImgItem, iCnvWidth, iCnvHeight, siType)
    end)

    graphics_draw_canvas(pVwCnv, iPx, iPy, 0)
end

function draw_item_canvas(pImgItem, iCount, iPx, iPy, iWidth, iHeight, siType)
    draw_item_tile(pImgItem, iPx, iPy, iWidth, iHeight, siType)
    draw_item_count(iCount, iPx, iPy, iWidth, iHeight, siType)
end
