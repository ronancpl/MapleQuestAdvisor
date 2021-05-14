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
require("struct.component.canvas.style.box.limit")
require("struct.component.canvas.style.box.text")
require("ui.constant.path")
require("ui.constant.view.inventory")
require("ui.constant.view.style")
require("ui.run.draw.canvas.style.text_box")
require("ui.struct.component.canvas.resource.mini_table")
require("ui.struct.component.element.texture")
require("utils.struct.class")

CStyleBoxMapno = createClass({
    eTexture = CTextureElem:new(),
    pBoxRsc = CRscMinitableElem:new(),
    pBoxText = CStyleText:new(),
    pBoxLimits = CStyleLimit:new(),

    bVisible = false
})

function CStyleBoxMapno:get_object()
    return self.eTexture
end

function CStyleBoxMapno:get_resources()
    return self.pBoxRsc
end

function CStyleBoxMapno:get_contents()
    return self.pBoxText
end

function CStyleBoxMapno:get_limits()
    return self.pBoxLimits
end

function CStyleBoxMapno:_load_texture(iRx, iRy)
    local m_eTexture = self.eTexture

    local pImgBox = love.graphics.newImage(ctVwStyle:get_image_data(RWndPath.INTF_SBOX))
    m_eTexture:load(iRx, iRy, pImgBox, 3, 3, 115, 6)
end

function CStyleBoxMapno:_load_fonts()
    local m_pBoxLimits = self.pBoxLimits
    m_pBoxLimits:reset()

    local m_pBoxText = self.pBoxText
    m_pBoxText:load_font("arialbd.ttf", 12, "arial.ttf", 12)
end

function CStyleBoxMapno:_load_text(sTitle, sDesc)
    local m_pBoxText = self.pBoxText
    m_pBoxText:update_text(sTitle, sDesc)
end

function CStyleBoxMapno:_calc_texture_box_dimensions()
    local m_pBoxText = self.pBoxText
    local m_pBoxLimits = self.pBoxLimits

    local iWidth, iHeight = calc_current_boundary(m_pBoxText, m_pBoxLimits)
    local sWidth, sHeight = m_pBoxText:get_text()

    return iWidth, iHeight
end

function CStyleBoxMapno:_build_texture_box(iRx, iRy)
    local m_eTexture = self.eTexture

    local iWidth, iHeight = self:_calc_texture_box_dimensions()
    m_eTexture:build(iWidth, iHeight)
end

function CStyleBoxMapno:_update_resources(pRscProp)
    update_items_for_resource_mini_table(self.pBoxRsc, pRscProp)
end

function CStyleBoxMapno:_load_resources(pRscProp, iRx, iRy)
    if pRscProp ~= nil then
        local m_pBoxText = self.pBoxText
        local m_pBoxLimits = self.pBoxLimits
        local m_pBoxRsc = self.pBoxRsc

        local iTh
        _, iTh = calc_title_boundary(m_pBoxText, m_pBoxLimits)

        iRy = iRy + iTh + RStylebox.FIL_Y

        local iIx, iIy = iRx + RStylebox.FIL_X, iRy + RStylebox.FIL_Y
        m_pBoxRsc:load(pRscProp, iIx, iIy)

        m_pBoxLimits:set_image_dimensions(RStylebox.VW_ITEM.W, RStylebox.VW_ITEM.H)

        self:_update_resources(pRscProp)
    end
end

function CStyleBoxMapno:load(sTitle, sDesc, iRx, iRy, pRscProp)
    self:_load_texture(iRx, iRy)
    self:_load_fonts()
    self:_load_text(sTitle, sDesc)
    self:_load_resources(pRscProp, iRx, iRy)

    validate_box_boundary(self)

    self:_build_texture_box(iRx, iRy)
end

function CStyleBoxMapno:reset()
    -- do nothing
end

function CStyleBoxMapno:update(dt)
    local m_pBoxLimits = self.pBoxLimits

    local iMx, iMy = love.mouse.getPosition()
    m_pBoxLimits:update_box_position(iMx, iMy)
end

function CStyleBoxMapno:draw()
    if self.bVisible then
        draw_text_box(self)
    end
end

function CStyleBoxMapno:hidden()
    self.bVisible = false
end

function CStyleBoxMapno:visible()
    self.bVisible = true
end

function CStyleBoxMapno:is_visible()
    return self.bVisible
end
