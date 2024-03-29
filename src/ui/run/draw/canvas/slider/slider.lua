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
require("ui.struct.toolkit.graphics")

local function fetch_draw_rotation(pVwSlider)
    local bVert = pVwSlider:is_vert()
    return bVert and (3 / 2) * math.pi or 0
end

local function calc_slider_bar_fit(pVwSlider, iFilLen)
    local iLoop = math.ceil(pVwSlider:get_bar_length() / iFilLen)
    local bVert = pVwSlider:is_vert()

    return iLoop, bVert
end

local function draw_slider_bar_top(pImgLfBar, iX, iY, iR)
    graphics_draw(pImgLfBar, iX, iY, iR)
end

local function draw_slider_bar_base(pImgFilBar, iX, iY, iW, iH, iIncX, iIncY, iR, iLoop)
    graphics_set_scissor(iX, iY, iW, iH)    -- rational loop value

    local iPx = iX
    local iPy = iY
    for i = 1, iLoop, 1 do
        graphics_draw(pImgFilBar, iPx, iPy, iR)

        iPx = iPx + iIncX
        iPy = iPy + iIncY
    end

    graphics_set_scissor()
end

local function draw_slider_bar_bottom(pImgRgBar, iX, iY, iR)
    graphics_draw(pImgRgBar, iX, iY, iR)
end

local function draw_slider_bar(pVwSlider)
    local iLen = pVwSlider:get_bar_length()

    local pImgFilBase = pVwSlider:get_bar()
    local iFilMidLen, iFilMidGir = pImgFilBase:getDimensions()

    local iFilLen = iLen
    local iLoop, bVert = calc_slider_bar_fit(pVwSlider, iFilLen)

    local iX, iY = pVwSlider:get_origin()

    local iPx = iX
    local iPy = iY

    local iR = fetch_draw_rotation(pVwSlider)

    local iMidX, iMidY, iMidW, iMidH

    local iIncX, iIncY
    if bVert then
        iIncX = 0
        iIncY = math.ceil(iFilLen / iLoop)

        iW = iFilHgt
        iH = iLen

        iPx = iPx - math.ceil(iFilMidGir / 2)

        iMidX = iPx
        iMidY = iPy
        iMidW = iFilMidGir
        iMidH = iFilLen
    else
        iIncX = math.ceil(iFilLen / iLoop)
        iIncY = 0

        iW = iLen
        iH = iFilHgt

        iPy = iPy - math.ceil(iFilMidGir / 2)

        iMidX = iPx
        iMidY = iPy
        iMidW = iFilLen
        iMidH = iFilMidGir
    end

    love.graphics.setColor(0, 0, 1)

    draw_slider_bar_base(pImgFilBase, iMidX, iMidY, iMidW, iMidH, iIncX, iIncY, iR, iLoop)

    love.graphics.setColor(255, 255, 255, 1.0)
end

local function draw_slider_arrow(pVwSlider)
    local iNx, iNy, iPx, iPy = pVwSlider:get_arrow_positions()
    local iR = fetch_draw_rotation(pVwSlider)

    local pImgNext = pVwSlider:get_next()
    graphics_draw(pImgNext, iNx, iNy, iR)

    local pImgPrev = pVwSlider:get_prev()
    graphics_draw(pImgPrev, iPx, iPy, iR)
end

local function calc_slider_thumb_pos(pVwSlider)
    local iCur = pVwSlider:get_wheel_segment() - 1
    local iTotal = pVwSlider:get_num_segments() - 1

    local iPos

    local iRollLen = pVwSlider:get_trail_length()
    if iCur <= 0 then
        local iThumbGir = pVwSlider:get_thumb_girth()
        iPos = math.ceil(iThumbGir / 2)
    elseif iCur >= iTotal then
        local iArrGir = pVwSlider:get_arrow_girth()
        iPos = iRollLen - iArrGir
    else
        iPos = math.ceil((iCur / iTotal) * iRollLen)
    end

    return iPos
end

local function draw_slider_thumb(pVwSlider)
    local iArrLen = pVwSlider:get_arrow_length()

    local bVert = pVwSlider:is_vert()

    local iX, iY = pVwSlider:get_origin()

    local iPx = iX
    local iPy = iY + 2 * iArrLen

    local iRx = 0
    local iRy = 0
    if bVert then
        iPx = iPx - math.ceil(pVwSlider:get_thumb_girth() / 2)
        iRy = calc_slider_thumb_pos(pVwSlider)
    else
        iRx = calc_slider_thumb_pos(pVwSlider)
        iPy = iPy - math.ceil(pVwSlider:get_thumb_girth() / 2)
    end

    local m_eTexture = pVwSlider:get_thumb()
    m_eTexture:draw(iPx + iRx, iPy + iRy, fetch_draw_rotation(pVwSlider))
end

function draw_slider(pVwSlider)
    draw_slider_bar(pVwSlider)
    draw_slider_arrow(pVwSlider)
    draw_slider_thumb(pVwSlider)
end
