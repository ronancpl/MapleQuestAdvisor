--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("ui.run.update.canvas.position")
require("ui.struct.canvas.inventory.properties")
require("ui.struct.canvas.inventory.layer.item")
require("ui.struct.canvas.inventory.layer.table")
require("ui.struct.component.canvas.canvas")
require("ui.struct.window.type")
require("ui.struct.window.frame.canvas")
require("utils.struct.class")

CWndInventory = createClass({CWndBase, {
    pCanvas = CWndCanvas:new(),
    pProp = CInvtProperties:new()
}})

function CWndInventory:update_inventory(pIvtItems)
    self.pCanvas:reset()

    self.pCanvas:build(self.pProp)
    self.pProp:update_inventory(pIvtItems)
end

function CWndInventory:get_window_position()
    return self:get_position()
end

function CWndInventory:set_window_position(iRx, iRy)
    self:set_position(iRx, iRy)
end

function CWndInventory:set_dimensions(iWidth, iHeight)
    self:_set_window_size(iWidth, iHeight)
end

function CWndInventory:load()
    local iBx
    local iBy
    local pImg = ctVwInvt:get_background()
    iBx, iBy = pImg:getDimensions()

    self:_load(iBx, iBy, RWndBtClose.TYPE2)

    self:set_dimensions(iBx, iBy)

    self.pCanvas:load({CInventoryNavTable, CInventoryNavItems})
    self.pProp:load()
end

function CWndInventory:update(dt)
    self:_update(dt)
    self.pCanvas:update(dt)
end

function CWndInventory:draw()
    local iRx, iRy = self:get_window_position()

    push_stack_canvas_position(iRx, iRy)
    self.pCanvas:draw()
    pop_stack_canvas_position()

    self:_draw()
end

function CWndInventory:onmousemoved(x, y, dx, dy, istouch)
    self:_onmousemoved(x, y, dx, dy, istouch)

    local iPx, iPy = self:fetch_relative_pos(x, y)
    self.pCanvas:onmousemoved(iPx, iPy, dx, dy, istouch)
end

function CWndInventory:onmousepressed(x, y, button)
    self:_onmousepressed(x, y, button)

    local iPx, iPy = self:fetch_relative_pos(x, y)
    self.pCanvas:onmousepressed(iPx, iPy, button)
end

function CWndInventory:onmousereleased(x, y, button)
    self:_onmousereleased(x, y, button)

    local iPx, iPy = self:fetch_relative_pos(x, y)
    self.pCanvas:onmousereleased(iPx, iPy, button)
end

function CWndInventory:onwheelmoved(dx, dy)
    self:_onwheelmoved(dx, dy)
    self.pCanvas:onwheelmoved(dx, dy)
end

function CWndInventory:get_layer(iLayer)
    return self.pCanvas:get_layer(iLayer)
end
