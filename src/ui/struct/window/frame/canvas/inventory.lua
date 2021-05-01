--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("ui.struct.canvas.inventory.properties")
require("ui.struct.canvas.inventory.layer.item")
require("ui.struct.canvas.inventory.layer.table")
require("ui.struct.window.frame.canvas")
require("utils.struct.class")

CWndInventory = createClass({
    pCanvas = CWndCanvas:new(),
    pProp = CInvtProperties:new()
})

function CWndInventory:update_inventory(pIvtItems)
    self.pCanvas:reset()

    self.pProp:update_inventory(pIvtItems)
    self.pCanvas:build(self.pProp)
end

function CWndInventory:load()
    self.pCanvas:load({CInventoryNavTable, CInventoryNavItems})
    self.pProp:load()
end

function CWndInventory:update(dt)
    self.pCanvas:update(dt)
end

function CWndInventory:draw()
    self.pCanvas:draw()
end

function CWndInventory:onmousemoved(x, y, dx, dy, istouch)
    self.pCanvas:onmousemoved(x, y, dx, dy, istouch)
end

function CWndInventory:onmousepressed(x, y, button)
    self.pCanvas:onmousepressed(x, y, button)
end

function CWndInventory:onmousereleased(x, y, button)
    self.pCanvas:onmousereleased(x, y, button)
end

function CWndInventory:onwheelmoved(dx, dy)
    self.pCanvas:onwheelmoved(dx, dy)
end

function CWndInventory:get_layer(iLayer)
    return self.pCanvas:get_layer(iLayer)
end
