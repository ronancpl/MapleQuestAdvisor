--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("ui.constant.view.style")
require("ui.struct.toolkit.graphics")

local function compose_box_text(pBoxText, pBoxLimit)
    local sTitle
    local sDesc
    sTitle, sDesc = pBoxText:get_text()

    local pFontTitle
    local pFontDesc
    pFontTitle, pFontDesc = pBoxText:get_font()

    local iLineWidth = pBoxLimit:get_width()

    local pTxtTitle = ctPoolFont:take_text(pFontTitle)
    pTxtTitle:setf({{1, 1, 1}, sTitle}, iLineWidth, "center")

    local pTxtDesc = ctPoolFont:take_text(pFontDesc)
    pTxtDesc:setf({{1, 1, 1}, sDesc}, iLineWidth, "left")

    pBoxText:update_format(pTxtTitle, pFontTitle, pTxtDesc, pFontDesc)
end

local function fetch_text_wrap(sText, iLimWidth, pFont)
    local rgsTextWrap
    local iWidth

    local iWidth
    iWidth, rgsTextWrap = pFont:getWrap(sText, iLimWidth)

    return iWidth, rgsTextWrap
end

local function calc_text_boundary(sText, iLimWidth, pFont)
    local iWidth
    local rgsTextWrap
    iWidth, rgsTextWrap = fetch_text_wrap(sText, iLimWidth, pFont)

    local iHeight = #rgsTextWrap * pFont:getHeight(sText)
    return iWidth, iHeight
end

local function calc_current_text_boundary(pBoxText, pBoxLimit)
    local sTitle
    local sDesc
    sTitle, sDesc = pBoxText:get_text()

    local pFontTitle
    local pFontDesc
    pFontTitle, pFontDesc = pBoxText:get_font()

    local iLineWidth = pBoxLimit:get_width()

    local iTw
    local iTh
    iTw, iTh = calc_text_boundary(sTitle, iLineWidth, pFontTitle)

    local iDw
    local iDh
    iDw, iDh = calc_text_boundary(sDesc, iLineWidth, pFontDesc)

    -- title/desc + new line
    return math.max(iTw, iDw), iTh + RStylebox.CRLF + iDh, iTh
end

function calc_title_boundary(pBoxText, pBoxLimit)
    local sTitle
    sTitle, _ = pBoxText:get_text()

    local pFontTitle
    pFontTitle, _ = pBoxText:get_font()

    local iLineWidth = pBoxLimit:get_width()

    local iTw
    local iTh
    iTw, iTh = calc_text_boundary(sTitle, iLineWidth, pFontTitle)

    return iTw, iTh
end

function calc_current_boundary(pBoxText, pBoxLimit)
    local iTw, iTh, iTitleH = calc_current_text_boundary(pBoxText, pBoxLimit)
    local iIw, iIh = pBoxLimit:get_image_dimensions()

    local iW = 0
    local iH = 0

    iW = iW + iTw
    iH = iH + iTh

    if iIw ~= nil then
        iW = iW + iIw + RStylebox.FIL_X
        iH = math.max(iTitleH + iIh, iH)
    end

    iW = iW + (2 * RStylebox.FIL_X)
    iH = iH + (2 * RStylebox.FIL_Y)

    return iW, iH
end

local function adjust_box_boundary(pBoxLimit)
    pBoxLimit:increment()
end

local function trim_box_width(pBoxLimit, iWidth)
    pBoxLimit:trim(iWidth)
end

function validate_box_boundary(pTextbox)
    local pBoxText = pTextbox:get_contents()
    local pBoxLimit = pTextbox:get_limits()

    local sTitle, sDesc = pBoxText:get_text()

    while true do
        local iWidth
        local iHeight
        iWidth, iHeight = calc_current_boundary(pBoxText, pBoxLimit)

        if iHeight < pBoxLimit:get_height() then
            trim_box_width(pBoxLimit, iWidth)   -- accommodate text field in style box canvas
            compose_box_text(pBoxText, pBoxLimit)

            break
        else
            adjust_box_boundary(pBoxLimit)
            compose_box_text(pBoxText, pBoxLimit)
        end
    end
end

local function draw_text_box_background(pTextbox)
    local eTexture = pTextbox:get_object()

    local pBoxLimit = pTextbox:get_limits()
    local iRx, iRy = pBoxLimit:get_box_position()

    eTexture:draw(iRx, iRy)
end

local function draw_text_box_image(pTextbox)
    local pImg = pTextbox:get_image()

    local pBoxLimit = pTextbox:get_limits()
    local iRx, iRy = pBoxLimit:get_box_position()

    pImg:draw(iRx, iRy)
end

local function draw_text_box_contents(pTextbox)
    draw_text_box_image(pTextbox)

    local pBoxText = pTextbox:get_contents()

    local pTxtTitle
    local pTxtDesc
    pTxtTitle, pTxtDesc = pBoxText:get_drawable()

    local pBoxLimit = pTextbox:get_limits()
    local iRx, iRy = pBoxLimit:get_box_position()

    local iTdx, _ = pBoxLimit:get_image_dimensions()
    if iTdx ~= nil then
        iTdx = iTdx + RStylebox.FIL_X
    else
        iTdx = 0
    end

    local sTitle
    sTitle, _ = pBoxText:get_text()

    local iRyDesc
    if string.len(sTitle) > 0 then
        iRyDesc = RStylebox.CRLF
    else
        iRyDesc = 0
    end

    graphics_draw(pTxtTitle, iRx + iTdx + RStylebox.FIL_X, iRy + RStylebox.FIL_Y)
    graphics_draw(pTxtDesc, iRx + iTdx + RStylebox.FIL_X, iRy + iRyDesc + RStylebox.FIL_Y)
end

function draw_text_box(pTextbox)
    draw_text_box_background(pTextbox)
    draw_text_box_contents(pTextbox)
end
