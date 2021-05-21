--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("ui.struct.component.basic.base")
require("ui.run.draw.canvas.slider.slider")
require("ui.run.update.canvas.position")
require("utils.struct.class")

RButtonState = {DISABLED = "disabled", MOUSE_OVER = "mouseOver", NORMAL = "normal", PRESSED = "pressed"}

CButtonElem = createClass({
    eElem = CBasicElem:new(),
    pImgBase,
    rgpArgs,
    fn_act
})

function CButtonElem:get_thumb()
    return self.eElem
end

function CButtonElem:get_origin()
    return self.eElem:get_pos()
end

function CButtonElem:set_origin(rX, rY)
    self.eElem:load(rX, rY)
end

function CButtonElem:get_base()
    return self.pImgBase
end

function CButtonElem:_load_button(sButtonName)
    local pImgBase = ctVwButton:get_button(sButtonName)
    self.pImgBase = pImgBase
end

function CButtonElem:update_state(sButtonState)
    self:_load_button(sButtonState)
end

function CButtonElem:set_fn_trigger(fn_act, ...)
    self.rgpArgs = {...}
    self.fn_act = fn_act
end

function CButtonElem:onmousereleased(x, y, button)
    local m_fn_act = self.fn_act
    if m_fn_act ~= nil then
        local m_rgpArgs = self.rgpArgs
        m_fn_act(unpack(m_rgpArgs))
    end
end

function CButtonElem:load(sButtonState, rX, rY)
    self:set_origin(rX, rY)
    self:update_state(sButtonState)
end

function CButtonElem:update(dt)
    -- do nothing
end

function CButtonElem:draw()
    local iRx, iRy = read_canvas_position()

    local iPx, iPy = self.eElem:get_pos()
    push_stack_canvas_position(iPx + iRx, iPy + iRy)
    draw_button(self)
    pop_stack_canvas_position()
end
