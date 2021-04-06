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

local function draw_slider_bar_mid(pImgFilBar, iX, iY, iW, iH, iIncX, iIncY, iR, iLoop)
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

    local pImgFilLfBar, pImgFilMidBar, pImgFilRgBar = ctVwSlider:get_bar()

    local iFilLfLen, iFilLfGir = pImgFilLfBar:getDimensions()
    local iFilMidLen, iFilMidGir = pImgFilMidBar:getDimensions()
    local iFilRgLen, iFilRgGir = pImgFilRgBar:getDimensions()

    local iFilLen = iLen - iFilLfLen - iFilRgLen
    local iLoop, bVert = calc_slider_bar_fit(pVwSlider, iFilLen)

    local iPx = iX
    local iPy = iY

    local iR = fetch_draw_rotation(pVwSlider)

    local iLfX, iLfY, iLfW, iLfH
    local iMidX, iMidY, iMidW, iMidH
    local iRgX, iRgY, iRgW, iRgH

    local iIncX, iIncY
    if bVert then
        iIncX = 0
        iIncY = math.ceil(iFilLen / iLoop)

        iW = iFilHgt
        iH = iLen

        iPx = iPx - math.floor(iFilMidGir / 2)

        iLfX = iPx
        iLfY = iPy
        iLfW = iFilLfGir
        iLfH = iFilLfLen

        iMidX = iLfX
        iMidY = iLfY + iLfH
        iMidW = iFilMidGir
        iMidH = iFilLen

        iRgX = iLfX
        iRgY = iMidY + iMidH
        iRgW = iFilRgGir
        iRgH = iFilRgLen
    else
        iIncX = math.ceil(iFilLen / iLoop)
        iIncY = 0

        iW = iLen
        iH = iFilHgt

        iPy = iPy - math.floor(iFilMidGir / 2)

        iLfX = iPx
        iLfY = iPy
        iLfW = iFilLfLen
        iLfH = iFilLfGir

        iMidX = iLfX + iLfW
        iMidY = iLfY
        iMidW = iFilLen
        iMidH = iFilMidGir

        iRgX = iMidX + iMidW
        iRgY = iLfY
        iRgW = iFilRgLen
        iRgH = iFilRgGir
    end

    love.graphics.setColor(0, 0, 1)

    draw_slider_bar_top(pImgFilLfBar, iLfX, iLfY)
    draw_slider_bar_mid(pImgFilMidBar, iMidX, iMidY, iMidW, iMidH, iIncX, iIncY, iR, iLoop)
    draw_slider_bar_bottom(pImgFilRgBar, iRgX, iRgY)

    love.graphics.setColor(255, 255, 255, 1.0)
end

local function draw_slider_arrow(pVwSlider, iX, iY)
    -- unused arrows
end

local function draw_slider_thumb(pVwSlider, iX, iY)
    -- determine thumb position

    local iCur = pVwSlider:get_current()
    local iTotal = pVwSlider:get_split()

    local iRollLen = pVwSlider:get_bar_length() - pVwSlider:get_thumb_length()

    local bVert = pVwSlider:get_orientation()

    local iPx = iX
    local iPy = iY

    local iRx = 0
    local iRy = 0
    if bVert then
        iPx = iPx - (pVwSlider:get_thumb_girth() / 2)
        iRy = (iCur / iTotal) * iRollLen
    else
        iRx = (iCur / iTotal) * iRollLen
        iPy = iPy - (pVwSlider:get_thumb_girth() / 2)
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
