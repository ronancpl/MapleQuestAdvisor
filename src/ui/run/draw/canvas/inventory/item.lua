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
require("ui.run.draw.canvas.inventory.tile.view")
require("ui.struct.toolkit.canvas")
require("ui.struct.toolkit.color")
require("ui.struct.toolkit.graphics")

local function draw_item_tile(pImgItem, iWidth, iHeight, siType, bUseShadow, bEqp, iOx, iOy)
    draw_canvas_item_tile(pImgItem, iWidth, iHeight, siType, bUseShadow, bEqp, iOx, iOy)
end

function load_item_canvas(pImgItem, iWidth, iHeight, siType, bUseShadow, bEqp, iOx, iOy)
    local pVwCnv = CViewCanvas:new()

    local iImgW, iImgH = pImgItem:getDimensions()
    local iCnvW = math.max(iWidth, iImgW)
    local iCnvH = math.max(iHeight, iImgH)
    pVwCnv:load(iCnvW, iCnvH)

    pVwCnv:render_to(function()
        love.graphics.clear()
        draw_item_tile(pImgItem, iWidth, iHeight, siType, bUseShadow, bEqp, iOx, iOy)
    end)

    return pVwCnv
end

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

local function draw_item_count(iCount, iPx, iPy, iWidth, iHeight)
    if iCount ~= nil then
        local rgpImgNums = ctVwInvt:get_images_by_number(iCount)

        local iAccW, iH = calc_count_dimensions(rgpImgNums)  -- count position at RB
        local iX = iPx + iWidth - iAccW
        local iY = iPy + iHeight - iH

        for _, pImgNum in ipairs(rgpImgNums) do
            graphics_draw(pImgNum, iX, iY)

            local iW
            iW, _ = pImgNum:getDimensions()

            iX = iX + iW
        end
    end
end

function draw_item_canvas(pVwCnvItem, iCount, iPx, iPy, iPicW, iPicH, iOx, iOy)
    iOx = iOx or 0
    iOy = iOy or 0

    local iIx, iIy = pVwCnvItem:get_origin()

    local iRx, iBy = pVwCnvItem:get_rb()
    iEx = math.floor(math.max(iPicW - iRx, 0) / 2)
    iEy = math.floor(math.max(iPicH - iBy, 0) / 2)

    iOx = iOx + iIx + iEx
    iOy = iOx + iIy + iEy

    graphics_draw_canvas(pVwCnvItem, iPx + iOx, iPy + iOy, 0)
    draw_item_count(iCount, iPx, iPy, iPicW, iPicH)
end
