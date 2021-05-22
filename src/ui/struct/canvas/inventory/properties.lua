--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("structs.storage.inventory")
require("ui.run.build.canvas.inventory.element.inventory")
require("utils.procedure.copy")
require("utils.procedure.unpack")
require("utils.struct.class")

CInvtProperties = createClass({
    pInvtPlayer
})

function CInvtProperties:load()
    self.pInvtPlayer = load_view_inventory(CInventory:new(), 0, 0)
end

function CInvtProperties:reset()
    self.pInvtPlayer:reload_inventory(CInventory:new())
end

function CInvtProperties:update_inventory(pIvtItems)
    self.pInvtPlayer:reload_inventory(pIvtItems)
end

function CInvtProperties:get_inventory()
    return self.pInvtPlayer
end
