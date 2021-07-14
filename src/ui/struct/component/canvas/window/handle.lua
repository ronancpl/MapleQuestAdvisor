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
require("ui.struct.component.element.rect")
require("utils.struct.class")

CHandleElem = createClass({
    eBox = CUserboxElem:new(),
    fn_act,
    fn_reg_sure,
    fn_unreg_sure
})

function CHandleElem:get_object()
    return self.eBox
end

function CHandleElem:get_origin()
    return self.eBox:get_origin()
end

function CHandleElem:set_origin(x, y)
    local m_fn_act = self.fn_act    -- in-canvas relative pos unchanged, whole canvas pos changes
    m_fn_act(x, y)
end

function CHandleElem:set_fn_trigger(fn_act)
    self.fn_act = fn_act
end

function CHandleElem:set_fn_reg_sure(fn_sure)
    self.fn_reg_sure = fn_sure
end

function CHandleElem:set_fn_unreg_sure(fn_sure)
    self.fn_unreg_sure = fn_sure
end

function CHandleElem:onmousemoved(x, y, dx, dy, istouch)
    if love.mouse.isDown(1) == true then
        self:set_origin(x, y)
    end
end

function CHandleElem:onmousepressed(x, y, button)
    self.fn_reg_sure(self)
end

function CHandleElem:onmousereleased(x, y, button)
    self.fn_unreg_sure(self)
end

function CHandleElem:load(iPx, iPy, iW, iH)
    self.eBox:load(iPx, iPy, iW, iH)
end

function CHandleElem:update(dt)
    -- do nothing
end

function CHandleElem:draw()
    -- do nothing
end
