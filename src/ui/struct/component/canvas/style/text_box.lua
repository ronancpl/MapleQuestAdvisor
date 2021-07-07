--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("router.constants.timer")
require("router.procedures.constant")
require("struct.component.canvas.style.box.limit")
require("struct.component.canvas.style.box.text")
require("ui.constant.view.resource")
require("ui.constant.view.inventory")
require("ui.constant.view.style")
require("ui.run.draw.canvas.style.text_box")
require("ui.run.update.canvas.position")
require("ui.struct.component.element.texture")
require("ui.struct.component.canvas.style.prefab.item")
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

    local pImgBox = ctVwStyle:get_image(RWndPath.INTF_SBOX)
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

function CStyleBoxText:_show_texture_box()
    local m_eTexture = self.eTexture

    if not m_eTexture:is_ready() then
        local iWidth, iHeight = self:_calc_texture_box_dimensions()
        m_eTexture:build(iWidth, iHeight)
    end

    ctInactiveTextures:remove(m_eTexture)   -- remove from unload list
end

function CStyleBoxText:_hide_texture_box()
    local m_eTexture = self.eTexture
    if m_eTexture:is_ready() then
        ctInactiveTextures:insert(m_eTexture, 1, RTimer.TM_TEXTURE_TBOX)   -- add to unload list
    end
end

function CStyleBoxText:_load_image(pImgData, iRx, iRy)
    if pImgData ~= nil then
        local m_pBoxText = self.pBoxText
        local m_pBoxLimits = self.pBoxLimits
        local m_pBoxImg = self.pBoxImg

        local iTh
        _, iTh = calc_title_boundary(m_pBoxText, m_pBoxLimits)

        iRy = iRy + iTh + RStylebox.FIL_Y

        local iIx, iIy = iRx + RStylebox.FIL_X, iRy + RStylebox.FIL_Y
        m_pBoxImg:load(pImgData, iIx, iIy)

        m_pBoxLimits:set_image_dimensions(RStylebox.VW_ITEM.W, RStylebox.VW_ITEM.H)
    end
end

function CStyleBoxText:load(sTitle, sDesc, iRx, iRy, pImgData)
    self:_load_texture(iRx, iRy)
    self:_load_fonts()
    self:_load_text(sTitle, sDesc)
    self:_load_image(pImgData, iRx, iRy)

    validate_box_boundary(self)
end

function CStyleBoxText:reset()
    -- do nothing
end

function CStyleBoxText:free()
    self.pBoxText:free()
end

function CStyleBoxText:update(dt)
    -- do nothing
end

function CStyleBoxText:draw()
    local iMx, iMy = love.mouse.getPosition()
    local iRx, iRy = read_canvas_position()

    local m_pBoxLimits = self.pBoxLimits
    m_pBoxLimits:update_box_position(iMx - iRx, iMy - iRy)

    if self.bVisible then
        draw_text_box(self)
    end
end

function CStyleBoxText:hidden()
    self.bVisible = false

    self:_hide_texture_box()
end

function CStyleBoxText:visible()
    self.bVisible = true

    self:_show_texture_box()
end

function CStyleBoxText:is_visible()
    return self.bVisible
end
