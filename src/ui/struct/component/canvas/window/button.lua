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
require("ui.struct.component.canvas.window.state")
require("ui.struct.component.element.dynamic")
require("utils.struct.class")

CButtonElem = createClass({
    eDynam = CDynamicElem:new(),
    trgpQuads = {},
    sState,
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

function CButtonElem:reset()
    -- do nothing
end

function CButtonElem:get_ltrb()
    return self.eDynam:get_ltrb()
end

local function fetch_button_name(sButtonPath)
    local iIdx = string.rfind(sButtonPath, "/") or 0
    return (sButtonPath:sub(iIdx+1))
end

function CButtonElem:update_button(sButtonImg)
    local trgpQuads = ctVwButton:get_button(fetch_button_name(sButtonImg))

    local m_trgpQuads = self.trgpQuads
    clear_table(m_trgpQuads)
    table_merge(m_trgpQuads, trgpQuads)
end

function CButtonElem:get_state()
    return self.sState
end

function CButtonElem:update_state(sButtonState)
    local m_trgpQuads = self.trgpQuads

    self.sState = sButtonState
    local rgpQuads = m_trgpQuads[sButtonState]

    local rX, rY = self:get_origin()
    self.eDynam:load(rX, rY, rgpQuads)
    self.eDynam:instantiate()
    self.eDynam:after_load()
    self.eDynam:set_static(false)
end

function CButtonElem:set_fn_trigger(fn_act, ...)
    self.rgpArgs = ... or {}
    self.fn_act = fn_act
end

function CButtonElem:update_fn_trigger(fn_act, ...)
    local m_rgpArgs = self.rgpArgs
    local rgpUpdArgs = ... or {}

    for i = 1, #rgpUpdArgs, 1 do
        m_rgpArgs[i] = rgpUpdArgs[i] or m_rgpArgs[i]
    end

    self.fn_act = fn_act or self.fn_act
end

function CButtonElem:_is_mouse_in_range(x, y)
    local iLx, iTy, iRx, iBy = self:get_ltrb()
    return math.between(x, iLx, iRx) and math.between(y, iTy, iBy)
end

function CButtonElem:onmousehoverin()
    if self:get_state() == RButtonState.DISABLED then return end
    self:update_state(love.mouse.isDown(1) and RButtonState.PRESSED or RButtonState.MOUSE_OVER)
end

function CButtonElem:onmousehoverout()
    if self:get_state() == RButtonState.DISABLED then return end
    self:update_state(RButtonState.NORMAL)
end

function CButtonElem:onmousepressed(x, y, button)
    if button == 1 then
        if self:get_state() == RButtonState.DISABLED then return end
        self:update_state(RButtonState.PRESSED)
    end
end

function CButtonElem:onmousereleased(x, y, button)
    if button == 1 then
        if self:get_state() == RButtonState.DISABLED then return end
        self:update_state(self:_is_mouse_in_range(x, y) and RButtonState.MOUSE_OVER or RButtonState.NORMAL)

        local m_fn_act = self.fn_act
        if m_fn_act ~= nil then
            local m_rgpArgs = self.rgpArgs
            m_fn_act(unpack(m_rgpArgs))
        end
    end
end

function CButtonElem:load(sButtonImg, rX, rY)
    self:set_origin(rX or 0, rY or 0)
    self:update_button(sButtonImg)
    self:update_state(RButtonState.NORMAL)
end

function CButtonElem:update(dt)
    -- do nothing
end

function CButtonElem:draw()
    draw_button(self)
end
