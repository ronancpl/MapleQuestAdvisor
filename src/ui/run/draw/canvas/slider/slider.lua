--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

local function fetch_draw_rotation(pVwSlider)
    local bVert = pVwSlider:get_orientation()
    return bVert and (3 / 2) * math.pi or 0
end

local function calc_slider_bar_fit(pVwSlider, iFilLen)
    local iLoop = math.ceil(pVwSlider:get_bar_length() / iFilLen)
    local bVert = pVwSlider:get_orientation()

    return iLoop, bVert
end

local function draw_slider_bar_top(pImgLfBar, iX, iY, iR)
    --love.graphics.draw(pImgLfBar, iX, iY, iR)

    local iW, iH = pImgLfBar:getDimensions()
    love.graphics.rectangle("fill", iX, iY, iR == 0 and iW or iH, iR ~= 0 and iH or iW)
end

local function draw_slider_bar_base(pImgFilBar, iX, iY, iW, iH, iIncX, iIncY, iR, iLoop)
    love.graphics.setScissor(iX, iY, iW, iH)    -- rational loop value

    local iPx = iX
    local iPy = iY
    for i = 1, iLoop, 1 do
        --love.graphics.draw(pImgFilBar, iPx, iPy, iR)
        love.graphics.rectangle("fill", iPx, iPy, iR == 0 and iIncX or iW, iR ~= 0 and iIncY or iH)

        iPx = iPx + iIncX
        iPy = iPy + iIncY
    end

    love.graphics.setScissor()
end

local function draw_slider_bar_bottom(pImgRgBar, iX, iY, iR)
    --love.graphics.draw(pImgRgBar, iX, iY, iR)

    local iW, iH = pImgRgBar:getDimensions()
    love.graphics.rectangle("fill", iX, iY, iR == 0 and iW or iH, iR ~= 0 and iH or iW)
end

local function draw_slider_bar(pVwSlider, iX, iY)
    local iLen = pVwSlider:get_bar_length()

    local pImgFilBase = pVwSlider:get_bar()
    local iFilMidLen, iFilMidGir = pImgFilBase:getDimensions()

    local iFilLen = iLen
    local iLoop, bVert = calc_slider_bar_fit(pVwSlider, iFilLen)

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

    draw_slider_bar_base(pImgFilMidBar, iMidX, iMidY, iMidW, iMidH, iIncX, iIncY, iR, iLoop)

    love.graphics.setColor(255, 255, 255, 1.0)
end

local function draw_slider_arrow(pVwSlider, iX, iY)
    local bVert = pVwSlider:get_orientation()

    local iRx = 0
    local iRy = 0

    local pImgFilBase = pVwSlider:get_bar()
    local _, iFilMidGir = pImgFilBase:getDimensions()

    local iPx = iX
    local iPy = iY

    local iBarLen = pVwSlider:get_bar_length()

    local iArrLen = pVwSlider:get_arrow_length()
    local iArrGir = pVwSlider:get_arrow_girth()

    if bVert then
        iPx = iPx - math.ceil(iFilMidGir / 2)
        iPy = iPy + iArrGir

        iRy = iBarLen - iArrGir
    else
        iPx = iPx + iArrGir
        iPy = iPy - math.ceil(iFilMidGir / 2)

        iRx = iBarLen - iArrGir
    end

    local iR = fetch_draw_rotation(pVwSlider)

    local pImgNext = pVwSlider:get_next()
    love.graphics.draw(pImgNext, iPx, iPy, iR)

    local pImgPrev = pVwSlider:get_prev()
    love.graphics.draw(pImgPrev, iPx + iRx, iPy + iRy, iR)
end

local function draw_slider_thumb(pVwSlider, iX, iY)
    -- determine thumb position

    local iCur = pVwSlider:get_current()
    local iTotal = pVwSlider:get_split()

    local iArrLen = pVwSlider:get_arrow_length()
    local iRollLen = pVwSlider:get_bar_length() - pVwSlider:get_thumb_length() - (2 * iArrLen)

    local bVert = pVwSlider:get_orientation()

    local iPx = iX
    local iPy = iY + 2 * iArrLen

    local iRx = 0
    local iRy = 0
    if bVert then
        iPx = iPx - math.ceil(pVwSlider:get_thumb_girth() / 2)
        iRy = math.ceil((iCur / iTotal) * iRollLen)
    else
        iRx = math.ceil((iCur / iTotal) * iRollLen)
        iPy = iPy - math.ceil(pVwSlider:get_thumb_girth() / 2)
    end

    local m_eTexture = pVwSlider:get_thumb()
    m_eTexture:draw(iPx + iRx, iPy + iRy, fetch_draw_rotation(pVwSlider))
end

function draw_slider(pVwSlider, iPx, iPy)
    iPx = iPx + RStylebox.VW_INVT_SLIDER.X
    iPy = iPy + RStylebox.VW_INVT_SLIDER.Y

    draw_slider_bar(pVwSlider, iPx, iPy)
    draw_slider_arrow(pVwSlider, iPx, iPy)
    draw_slider_thumb(pVwSlider, iPx, iPy)
end
