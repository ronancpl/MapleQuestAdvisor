--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

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

local function fetch_item_tile_box(pImgItem, iPx, iPy)
    local iW, iH = pImgItem:getDimensions()

    local iBw = RStylebox.VW_INVT_ITEM.W
    local iBh = RStylebox.VW_INVT_ITEM.H

    local fW = iW / iBw, 1.0
    local fH = iH / iBh, 1.0
    iW = fW * iBw
    iH = fH * iBh

    local iCx = iPx + (iBw / 2)
    local iCy = iPy + (iBh / 2)

    local iImgPx = iCx - (iW / 2)
    local iImgPy = iCy - (iH / 2)

    return iImgPx, iImgPy, iW, iH
end

local function draw_item_tile(pImgItem, iPx, iPy, iWidth, iHeight)
    -- draw item background
    local pImgShd = ctVwInvt:get_shadow()

    local iShW
    local iShH
    iShW, iShH = pImgShd:getDimensions()

    local iImgPx, iImgPy, iWidth, iHeight = fetch_item_tile_box(pImgItem, iPx, iPy)

    local iShWidth = math.min(iWidth, iShW)

    -- draw shadow
    graphics_draw(pImgShd, iPx, iPy + RStylebox.VW_INVT_ITEM.H - iShH, 0, iWidth, nil)

    -- draw item image
    graphics_draw(pImgItem, iImgPx, iImgPy, 0, iWidth, iHeight)
end

function draw_item_canvas(pImgItem, iCount, iPx, iPy, iWidth, iHeight)
    draw_item_tile(pImgItem, iPx, iPy, iWidth, iHeight)
    draw_item_count(iCount, iPx, iPy, iWidth, iHeight)
end
