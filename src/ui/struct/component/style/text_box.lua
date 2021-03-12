--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("struct.component.style.box.limit")
require("struct.component.style.box.text")
require("struct.component.style.box.texture")
require("ui.path.textbox")
require("ui.run.draw.box.limit")
require("ui.struct.component.basic.base")
require("utils.struct.class")

CStyleBoxText = createClass({
    eBase = CBasicElem:new(),

    pBoxText = CStyleText:new(),
    pBoxTexture = CStyleBox:new(),
    pBoxLimits = CStyleLimit:new()
})

function CStyleBoxText:_load_texture()
    local m_pBoxTexture = self.pBoxTexture

    local pImgBox = love.graphics.newImage(RInterface.LOVE_IMAGE_DIR_PATH .. RInterface.SBOX_DESC)
    m_pBoxTexture:load(pImgBox, 3, 3, 115, 6)
end

function CStyleBoxText:_load_fonts()
    local m_pBoxLimits = self.pBoxLimits
    m_pBoxLimits:reset()

    local m_pBoxText = self.pBoxText
    m_pBoxText:load_font("arialbd.ttf", 16, "arial.ttf", 16)
end

function CStyleBoxText:_load_text(sTitle, sDesc)
    local m_pBoxText = self.pBoxText
    m_pBoxText:update_text(sTitle, sDesc)
end

function CStyleBoxText:load(sTitle, sDesc, iRx, iRy)
    self.eBase:load(iRx, iRy)

    self:_load_texture()
    self:_load_fonts()
    self:_load_text(sTitle, sDesc)

    local m_pBoxText = self.pBoxText
    local m_pBoxLimits = self.pBoxLimits
    validate_box_boundary(m_pBoxText, m_pBoxLimits)
end

function CStyleBoxText:update(dt)
    local m_pBoxLimits = self.pBoxLimits
    m_pBoxLimits:update_box_position(love.mouse.getPosition())
end

function CStyleBoxText:_draw_text_box_background(iRx, iRy)
    local m_pBoxTexture = self.pBoxTexture
    local m_pBoxLimits = self.pBoxLimits

    m_pBoxTexture:draw(iRx, iRy, m_pBoxLimits:get_width(), m_pBoxLimits:get_height())
end

function CStyleBoxText:_draw_text_box()
    local m_pBoxLimits = self.pBoxLimits
    local iRx, iRy = m_pBoxLimits:get_box_position()

    self:_draw_text_box_background(iRx, iRy)

    local pTxtTitle
    local pTxtDesc
    local m_pBoxText = self.pBoxText
    pTxtTitle, pTxtDesc = m_pBoxText:get_drawable()

    love.graphics.draw(pTxtTitle, iRx + RStylebox.FIL_X, iRy + RStylebox.FIL_Y)
    love.graphics.draw(pTxtDesc, iRx + RStylebox.FIL_X, iRy + RStylebox.FIL_Y)
end

function CStyleBoxText:draw()
    self:_draw_text_box()
end
