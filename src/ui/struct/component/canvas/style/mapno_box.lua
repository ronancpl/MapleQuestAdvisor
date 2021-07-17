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

function CStyleBoxMapno:get_image()
    return self.pBoxRsc
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

    local pImgBox = ctVwStyle:get_image(RWndPath.INTF_SBOX)
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
    return iWidth, iHeight
end

function CStyleBoxMapno:_show_texture_box()
    local m_eTexture = self.eTexture
    if not m_eTexture:is_ready() then
        local iWidth, iHeight = self:_calc_texture_box_dimensions()
        m_eTexture:build(iWidth, iHeight)
    end

    ctInactiveTextures:remove(m_eTexture)   -- remove from unload list
end

function CStyleBoxMapno:_hide_texture_box()
    local m_eTexture = self.eTexture
    if m_eTexture:is_ready() then
        ctInactiveTextures:insert(m_eTexture, 1, RTimer.TM_TEXTURE_TBOX)   -- add to unload list
    end
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
        m_pBoxRsc:load(iIx, iIy)

        self:_update_resources(pRscProp)

        -- minitable dimensions
        local iTbW
        local iTbH
        iTbW, iTbH = fetch_table_dimensions(m_pBoxRsc, pTableConfVw, rgpTabConfVw, siTabIdx)

        m_pBoxLimits:set_image_dimensions(iTbW, iTbH)
    end
end

function CStyleBoxMapno:load(sTitle, sDesc, iRx, iRy, pRscProp)
    self:_load_texture(iRx, iRy)
    self:_load_fonts()
    self:_load_text(sTitle, sDesc)
    self:_load_resources(pRscProp, iRx, iRy)

    validate_box_boundary(self)
end

function CStyleBoxMapno:reset()
    -- do nothing
end

function CStyleBoxMapno:update(dt)
    local iMx, iMy = love.mouse.getPosition()

    local m_pBoxLimits = self.pBoxLimits
    m_pBoxLimits:update_box_position(iMx, iMy)

    local m_pBoxRsc = self.pBoxRsc
    local iRx, iRy = m_pBoxLimits:get_box_position()
    m_pBoxRsc:update_position(iRx, iRy)
end

function CStyleBoxMapno:draw()
    if self.bVisible then
        draw_text_box(self)
    end
end

function CStyleBoxMapno:hidden()
    self.bVisible = false

    self:_hide_texture_box()
end

function CStyleBoxMapno:visible()
    self.bVisible = true

    self:_show_texture_box()
end

function CStyleBoxMapno:is_visible()
    return self.bVisible
end

function CStyleBoxMapno:free()
    self.pBoxText:free()
end
