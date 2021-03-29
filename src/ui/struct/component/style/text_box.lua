--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("router.procedures.constant")
require("struct.component.style.box.limit")
require("struct.component.style.box.text")
require("ui.constant.style")
require("ui.run.draw.box.limit")
require("ui.struct.component.element.texture")
require("ui.struct.component.style.prefab.item")
require("utils.struct.class")

CStyleBoxText = createClass({
    eTexture = CTextureElem:new(),

    pBoxImg = CStyleBoxItem:new(),
    pBoxText = CStyleText:new(),
    pBoxLimits = CStyleLimit:new(),

    bVisible = false
})

function CStyleBoxText:get_object()
    return self.eTexture
end

function CStyleBoxText:get_image()
    return self.pBoxImg
end

function CStyleBoxText:get_contents()
    return self.pBoxText
end

function CStyleBoxText:get_limits()
    return self.pBoxLimits
end

function CStyleBoxText:_load_texture(iRx, iRy)
    local m_eTexture = self.eTexture

    local pImgBox = love.graphics.newImage(pFrameStylebox:get_image_data(RWndPath.INTF_SBOX))
    m_eTexture:load(iRx, iRy, pImgBox, 3, 3, 115, 6)
end

function CStyleBoxText:_load_fonts()
    local m_pBoxLimits = self.pBoxLimits
    m_pBoxLimits:reset()

    local m_pBoxText = self.pBoxText
    m_pBoxText:load_font("arialbd.ttf", 12, "arial.ttf", 12)
end

function CStyleBoxText:_load_text(sTitle, sDesc)
    local m_pBoxText = self.pBoxText
    m_pBoxText:update_text(sTitle, sDesc)
end

function CStyleBoxText:_calc_texture_box_dimensions()
    local m_pBoxText = self.pBoxText
    local m_pBoxLimits = self.pBoxLimits

    local iWidth, iHeight = calc_current_boundary(m_pBoxText, m_pBoxLimits)
    return iWidth, iHeight
end

function CStyleBoxText:_build_texture_box(iRx, iRy)
    local m_eTexture = self.eTexture

    local iWidth, iHeight = self:_calc_texture_box_dimensions()
    m_eTexture:build(iWidth, iHeight)
end

function CStyleBoxText:_load_image(pImg, iRx, iRy)
    local m_pBoxText = self.pBoxText
    local m_pBoxLimits = self.pBoxLimits
    local m_pBoxImg = self.pBoxImg

    local iTh
    _, iTh = calc_title_boundary(m_pBoxText, m_pBoxLimits)

    iRy = iRy + iTh + RStylebox.FIL_Y

    local iIx, iIy = iRx + RStylebox.FIL_X, iRy + RStylebox.FIL_Y
    m_pBoxImg:load(pImg, iIx, iIy)

    m_pBoxLimits:set_image_dimensions(RStylebox.VW_ITEM.W, RStylebox.VW_ITEM.H)
end

function CStyleBoxText:load(sTitle, sDesc, iRx, iRy, pImg)
    self:_load_texture(iRx, iRy)
    self:_load_fonts()
    self:_load_text(sTitle, sDesc)
    self:_load_image(pImg, iRx, iRy)

    validate_box_boundary(self)

    self:_build_texture_box(iRx, iRy)
end

function CStyleBoxText:reset()
    -- do nothing
end

function CStyleBoxText:update(dt)
    local m_pBoxLimits = self.pBoxLimits

    local iMx, iMy = love.mouse.getPosition()
    m_pBoxLimits:update_box_position(iMx, iMy)
end

function CStyleBoxText:draw()
    if self.bVisible then
        draw_text_box(self)
    end
end

function CStyleBoxText:hidden()
    self.bVisible = false
end

function CStyleBoxText:visible()
    self.bVisible = true
end

function CStyleBoxText:onmousehoverin()
    -- do nothing
end

function CStyleBoxText:onmousehoverout()
    -- do nothing
end

function CStyleBoxText:onmousemoved(rx, ry, dx, dy, istouch)
    -- do nothing
end

function CStyleBoxText:onmousepressed(rx, ry, button)
    -- do nothing
end

function CStyleBoxText:onmousereleased(rx, ry, button)
    -- do nothing
end
