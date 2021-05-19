--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("ui.run.draw.canvas.style.texture")
require("ui.run.load.interface.image")
require("ui.run.update.canvas.position")
require("ui.struct.component.basic.base")
require("ui.struct.component.basic.texture")
require("ui.struct.window.summary")
require("utils.struct.class")

CTextElem = createClass({
    eElem = CBasicElem:new(),

    rgiLtrb,
    pTxt,
    sText
})

function CTextElem:get_origin()
    return self.eElem:get_pos()
end

function CTextElem:get_z()
    return LChannel.WMAP_PLAINTXT
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

function CTextElem:_calc_ltrb(sText, iLineWidth, pFont)
    local iLx, iTy, iRx, iBy
    iLx, iTy = self.eElem:get_pos()

    local iW, iH = calc_text_boundary(sText, iLineWidth, pFont)
    iRx = iLx + iW
    iBy = iTy + iH

    return {iLx, iTy, iRx, iBy}
end

function CTextElem:get_ltrb()
    local iLx, iTy, iRx, iBy = unpack(self.rgiLtrb)
    return iLx, iTy, iRx, iBy
end

function CTextElem:load(sText, pFont, iLineWidth, iPx, iPy)
    self.eElem:load(iPx, iPy)

    local pTxt = love.graphics.newText(pFont)
    pTxt:setf({{0, 0, 0}, sText}, iLineWidth, "left")

    self.sText = sText
    self.pTxt = pTxt
    self.rgiLtrb = self:_calc_ltrb(sText, iLineWidth, pFont)
end

function CTextElem:update(dt)
    -- do nothing
end

function CTextElem:draw()
    local iRx, iRy = read_canvas_position()

    iRx = iRx or 0
    iRy = iRy or 0

    local iPx, iPy = self:get_origin()
    love.graphics.draw(self.pTxt, iPx + iRx, iPy + iRy)
end
