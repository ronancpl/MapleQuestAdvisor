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
    local rgpImgNums = ctVwInvt:get_images_by_number(iCount)

    local iAccW, iH = calc_count_dimensions(rgpImgNums)  -- count position at RB
    local iX = iPx + iWidth - iAccW
    local iY = iPy + iHeight - iH

    for _, pImgNum in ipairs(rgpImgNums) do
        love.graphics.draw(pImgNum, iX, iY)

        local iW
        iW, _ = pImgName:getDimensions()

        iX = iX + iW
    end
end

local function draw_item_tile(pImgItem, iPx, iPy, iWidth, iHeight)
    -- draw item background
    lock_graphics_color(194, 194, 209)
    love.graphics.rectangle("fill", iPx, iPy, iWidth, iHeight)
    unlock_graphics_color()

    local pImgShd = ctVwInvt:get_shadow()

    local iShW
    local iShH
    iShW, iShH = pImgShd:getDimensions()

    local fW = iWidth / iShW
    iShH = iShH * fW

    -- draw shadow
    graphics_draw(pImgShd, iPx, iPy + iHeight - iShH, 0, iWidth, nil)

    -- draw item image
    graphics_draw(pImgItem, iPx, iPy, 0, iWidth, nil)
end

function draw_item_canvas(pImgItem, iCount, iPx, iPy, iWidth, iHeight)
    draw_item_tile(pImgItem, iPx, iPy, iWidth, iHeight)
    draw_item_count(iCount, iPx, iPy, iWidth, iHeight)
end
