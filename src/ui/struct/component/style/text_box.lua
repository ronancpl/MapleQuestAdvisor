--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("ui.run.draw.box.texture")
require("ui.struct.component.basic.base")
require("utils.struct.class")

local SBOX_CRLF = 5
local SBOX_MIN_X = 100
local SBOX_MAX_X = 500
local SBOX_FIL_X = 10
local SBOX_UPD_X = 200

local SBOX_MIN_Y = 80
local SBOX_MAX_Y = 200
local SBOX_FIL_Y = 10
local SBOX_UPD_Y = SBOX_CRLF    -- + font height

local WND_X = 640
local WND_Y = 470

CStyleBoxText = createClass({
    eBase = CBasicElem:new(),

    sTitle,
    pFontTitle,
    pTxtTitle,

    sDesc,
    pFontDesc,
    pTxtDesc,

    iGrowth,
    iLineWidth,
    iHeight = 2 * SBOX_UPD_Y,

    pImgBox,
    rgpImgBoxQuads
})

function CStyleBoxText:_load_graphics()
    local pImgBox = love.graphics.newImage(RInterface.LOVE_IMAGE_DIR_PATH .. RInterface.SBOX_DESC)

    local rgpImgBoxQuads = fetch_texture_split(pImgBox, 3, 3, 118, 16)
    self.rgpImgBoxQuads = rgpImgBoxQuads

    self.pImgBox = pImgBox
end

function CStyleBoxText:_load_fonts()
    self.iGrowth = 0
    self.iLineWidth = SBOX_MIN_X

    self.pFontTitle = love.graphics.newFont(RInterface.LOVE_FONT_DIR_PATH .. "arialbd.ttf", 16)
    self.pFontDesc = love.graphics.newFont(RInterface.LOVE_FONT_DIR_PATH .. "arial.ttf", 16)
end

function CStyleBoxText:_compose_box_text()
    local m_pFontTitle = self.pFontTitle
    local pTxtTitle = love.graphics.newText(m_pFontTitle)
    pTxtTitle:setf({color1 = {1, 1, 1}, string1 = self.sTitle}, self.iLineWidth, "center")
    self.pTxtTitle = pTxtTitle

    local m_pFontDesc = self.pFontDesc
    local pTxtDesc = love.graphics.newText(m_pFontDesc)
    pTxtDesc:setf({color1 = {1, 1, 1}, string1 = self.sDesc}, self.iLineWidth, "justify")
    self.pTxtDesc = pTxtDesc
end

function CStyleBoxText:_set_box_text(sTitle, sDesc)
    self.sTitle = sTitle
    self.sDesc = sDesc

    self:_compose_box_text()
end

function CStyleBoxText:get_width()
    return self.iLineWidth
end

function CStyleBoxText:get_height()
    local m_pFontTitle = self.pFontTitle
    local m_pFontDesc = self.pFontDesc

    local m_sTitle = self.sTitle
    local m_sDesc = self.sDesc

    -- title/desc + 2 new lines
    return m_pFontTitle:getHeight(m_sTitle) + (2 * SBOX_CRLF) + m_pFontDesc:getHeight(m_sDesc)
end

function CStyleBoxText:_adjust_box_boundary()
    self.iGrowth = self.iGrowth + 1

    if self.iGrowth % 2 == 0 and self.iLineWidth < SBOX_MAX_X - (2 * SBOX_FIL_X) then
        self.iLineWidth = self.iLineWidth + SBOX_UPD_X
    else
        self.iHeight = self.iHeight + SBOX_UPD_Y
    end
end

function CStyleBoxText:_validate_box_boundary()
    while true do
        local iHeight = self:get_height()
        if iHeight < self.iHeight then
            break
        end

        self:_adjust_box_boundary()  -- accommodate text field in style box canvas
        self:_compose_box_text()
    end
end

function CStyleBoxText:load(sTitle, sDesc, iRx, iRy)
    self.eBase:load(iRx, iRy)

    self:_load_graphics()
    self:_load_fonts()

    self:_set_box_text(sTitle, sDesc)
    self:_validate_box_boundary()
end

function CStyleBoxText:_fetch_box_body_placement(iMx, iMy)
    local iWidth = self:get_width()
    if(iMx + iWidth < WND_X) then
        iRefX = iMx
    else
        iRefX = iMx - iWidth
    end

    local iHeight = self:get_height()
    if(iMy + iHeight < WND_Y) then
        iRefY = iMy
    else
        iRefY = iMy - iHeight
    end

    return iRefX, iRefY
end

function CStyleBoxText:update(dt)
    local iX, iY = self:_fetch_box_body_placement(love.mouse.getPosition())
    self.iRx = iX
    self.iRy = iY
end

function CStyleBoxText:_draw_text_box_background()
    draw_texture_box(self.pImgBox, self.rgpImgBoxQuads, self:get_width(), self:get_height(), self.iRx, self.iRy)
end

function CStyleBoxText:_draw_text_box()
    self:_draw_text_box_background()

    love.graphics.draw(self.pTxtTitle, self.iRx + SBOX_FIL_X, self.iRy + SBOX_FIL_Y)
    love.graphics.draw(self.pTxtDesc, self.iRx + SBOX_FIL_X, self.iRy + SBOX_FIL_Y)
end

function CStyleBoxText:draw()
    self:_draw_text_box()
end
