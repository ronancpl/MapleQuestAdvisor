--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("ui.run.draw.canvas.window.button")
require("ui.run.update.canvas.position")
require("ui.struct.component.element.dynamic")
require("utils.struct.class")

RButtonState = {DISABLED = "disabled", MOUSE_OVER = "mouseOver", NORMAL = "normal", PRESSED = "pressed"}

CButtonElem = createClass({
    eDynam = CDynamicElem:new(),
    bPressed = false,
    rgpArgs,
    fn_act,
    pBtClsVwConf
})

function CButtonElem:get_object()
    return self.eDynam
end

function CButtonElem:get_origin()
    return self.eDynam:get_pos()
end

function CButtonElem:set_origin(rX, rY)
    self.eDynam:set_pos(rX, rY)
end

function CButtonElem:_load_button(sButtonName)
    local rgpQuads = ctVwButton:get_button(sButtonName)

    local rX, rY = self:get_origin()
    self.eDynam:load(rX, rY, rgpQuads)
    self.eDynam:instantiate()
    self.eDynam:after_load()
    self.eDynam:set_static(false)
end

function CButtonElem:update_state(sButtonState)
    self:_load_button(sButtonState)
end

function CButtonElem:set_fn_trigger(fn_act, ...)
    self.rgpArgs = {...}
    self.fn_act = fn_act
end

function CButtonElem:onmousehoverin()
    self:update_state(love.mouse.isDown(1) and RButtonState.PRESSED or RButtonState.MOUSE_OVER)
end

function CButtonElem:onmousehoverout()
    self:update_state(RButtonState.NORMAL)
end

function CButtonElem:onmousereleased(x, y, button)
    local m_fn_act = self.fn_act
    if m_fn_act ~= nil then
        local m_rgpArgs = self.rgpArgs
        m_fn_act(unpack(m_rgpArgs))
    end
end

function CButtonElem:get_conf()
    return self.pBtClsVwConf
end

function CButtonElem:load(pBtClsVwConf, rX, rY)
    self.pBtClsVwConf = pBtClsVwConf
    self:set_origin(rX, rY)
    self:update_state(RButtonState.NORMAL)
end

function CButtonElem:update(dt)
    -- do nothing
end

function CButtonElem:draw()
    draw_button(self)
end
