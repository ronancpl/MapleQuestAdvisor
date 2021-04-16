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
require("ui.struct.toolkit.canvas")
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

local function draw_item_count(iCount, iPx, iPy, iWidth, iHeight)
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

local function fetch_item_tile_box(pImgItem, pImgShd, iPx, iPy, iBw, iBh)
    local iW, iH = pImgItem:getDimensions()

    local iShW
    local iShH
    iShW, iShH = pImgShd:getDimensions()

    local fW = iW / iBw
    local fH = iH / iBh
    iW = fW * iBw
    iH = fH * iBh

    local iOx = math.max(0, iBw - iW)
    local iOy = math.max(0, iBh - iH)

    local iCx = iPx + (iBw / 2)
    local iCy = iPy + (iBh / 2)

    local iImgPx = iCx - (iW / 2)
    local iImgPy = iCy - (iH / 2)

    local iShWidth = math.min(iW, iShW)
    local iShHeight = math.min(iH, iShH)

    local iShPx = iCx - (iShWidth / 2)
    local iShPy = iPy + iBh - iShH

    return iCx, iCy, iW, iH, iOx, iOy, iImgPx, iImgPy, iShWidth, iShHeight, iShPx, iShPy
end

local function draw_canvas_item_tile(pImgItem, iWidth, iHeight)
    local iPx, iPy = 0, 0

    -- draw item background
    local pImgShd = ctVwInvt:get_shadow()

    local iCx, iCy, iW, iH, iOx, iOy, iImgPx, iImgPy, iShWidth, iShHeight, iShPx, iShPy = fetch_item_tile_box(pImgItem, pImgShd, iPx, iPy, iWidth, iHeight)

    -- draw shadow
    graphics_canvas_draw(pImgShd, iShPx, iShPy, 0, iShWidth, nil)

    -- draw item image
    graphics_canvas_draw(pImgItem, iImgPx, iImgPy, 0, iW, iH, iOx, iOy)
end

local function draw_item_tile(pImgItem, iPx, iPy, iWidth, iHeight)
    local iCnvWidth = RInventory.VW_INVT_ITEM.W
    local iCnvHeight = RInventory.VW_INVT_ITEM.H

    local pVwCnv = CViewCanvas:new()
    pVwCnv:load(iCnvWidth, iCnvHeight)

    pVwCnv:render_to(function()
        love.graphics.clear()
        draw_canvas_item_tile(pImgItem, iCnvWidth, iCnvHeight)
    end)

    graphics_draw_canvas(pVwCnv, iPx, iPy, 0)
end

function draw_item_canvas(pImgItem, iCount, iPx, iPy, iWidth, iHeight)
    draw_item_tile(pImgItem, iPx, iPy, iWidth, iHeight)
    draw_item_count(iCount, iPx, iPy, iWidth, iHeight)
end
