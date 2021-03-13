--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("ui.path.textbox")

local function compose_box_text(pBoxText, pBoxLimit)
    local sTitle
    local sDesc
    sTitle, sDesc = pBoxText:get_text()

    local pFontTitle
    local pFontDesc
    pFontTitle, pFontDesc = pBoxText:get_font()

    local iLineWidth = pBoxLimit:get_width()

    local pTxtTitle = love.graphics.newText(pFontTitle)
    pTxtTitle:setf({{1, 1, 1}, sTitle}, iLineWidth, "center")

    local pTxtDesc = love.graphics.newText(pFontDesc)
    pTxtDesc:setf({{1, 1, 1}, sDesc}, iLineWidth, "left")

    pBoxText:update_format(pTxtTitle, pTxtDesc)
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

local function calc_current_height(pBoxText, pBoxLimit)
    local sTitle
    local sDesc
    sTitle, sDesc = pBoxText:get_text()

    local pFontTitle
    local pFontDesc
    pFontTitle, pFontDesc = pBoxText:get_font()

    local iLineWidth = pBoxLimit:get_width()

    local iTh
    _, iTh = calc_text_boundary(sTitle, iLineWidth, pFontTitle)

    local iDh
    _, iDh = calc_text_boundary(sDesc, iLineWidth, pFontDesc)

    -- title/desc + 2 new lines
    return iTh + (2 * RStylebox.CRLF) + iDh
end

local function adjust_box_boundary(pBoxLimit)
    pBoxLimit:increment()
end

function validate_box_boundary(pBoxText, pBoxLimit)
    while true do
        local iHeight = calc_current_height(pBoxText, pBoxLimit)

        local pFontTitle
        local pFontDesc
        pFontTitle, pFontDesc = pBoxText:get_font()

        local sTitle
        local sDesc
        sTitle, sDesc = pBoxText:get_text()

        if iHeight < pBoxLimit:get_height() then
            break
        end

        adjust_box_boundary(pBoxLimit)  -- accommodate text field in style box canvas
        compose_box_text(pBoxText, pBoxLimit)
    end
end
