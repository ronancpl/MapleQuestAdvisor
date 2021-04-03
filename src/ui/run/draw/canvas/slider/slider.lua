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
    return bVert and 270 or 0
end

local function calc_slider_bar_fit(pVwSlider, pImgFilBar)
    local iFilLen = pImgFilBar:getWidth()

    local iLoop = math.ceil(pVwSlider:get_bar_length() / iFilLen)
    local bVert = pVwSlider:get_orientation()

    return iLoop, bVert
end

local function draw_slider_bar(pVwSlider, iX, iY)
    local iLen = pVwSlider:get_bar_length()

    local pImgFilBar = ctVwSlider:get_bar()
    local iFilLen = pImgFilBar:getWidth()
    local iFilHgt = pImgFilBar:getHeight()

    local iLoop, bVert = calc_slider_bar_fit(pVwSlider, pImgFilBar)

    local iIncX, iIncY
    if bVert then
        iIncX = 0
        iIncY = iFilLen

        iW = iFilHgt
        iH = iLen
    else
        iIncX = iFilLen
        iIncY = 0

        iW = iLen
        iH = iFilHgt
    end

    local iPx = iX
    local iPy = iY

    love.graphics.setScissor(iPx, iPy, iW, iH)

    local iR = fetch_draw_rotation(pVwSlider)
    for i = 1, iLoop, 1 do
        love.graphics.draw(pImgFilBar, iPx, iPy, iR)

        iPx = iPx + iIncX
        iPy = iPy + iIncY
    end

    love.graphics.setScissor()

end

local function draw_slider_arrow(pVwSlider, iPx, iPy)
    -- unused arrows
end

local function draw_slider_thumb(pVwSlider, iPx, iPy)
    -- determine thumb position

    local iCur = pVwSlider:get_current()
    local iTotal = pVwSlider:get_split()

    local iRollLen = pVwSlider:get_bar_length() - pVwSlider:get_thumb_length()

    local bVert = pVwSlider:get_orientation()

    local iRx = 0
    local iRy = 0
    if bVert then
        iRy = (iCur / iTotal) * iRollLen
    else
        iRx = (iCur / iTotal) * iRollLen
    end

    local m_eTexture = pVwSlider:get_thumb()
    m_eTexture:draw(iPx + iRx, iPy + iRy, fetch_draw_rotation(pVwSlider))
end

function draw_slider(pVwSlider, iPx, iPy)
    draw_slider_bar(pVwSlider, iPx, iPy)
    draw_slider_arrow(pVwSlider, iPx, iPy)
    draw_slider_thumb(pVwSlider, iPx, iPy)
end
