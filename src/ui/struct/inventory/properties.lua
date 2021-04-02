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
require("ui.run.build.inventory.element.inventory")
require("utils.procedure.copy")
require("utils.procedure.unpack")
require("utils.struct.class")

CInvtProperties = createClass({
    pInvtPlayer
})

function CInvtProperties:reset()
    self.pInvtPlayer = load_view_inventory(CInventory:new(), 0, 0)
end

function CInvtProperties:load()
    self.pInvtPlayer = load_view_inventory(CInventory:new(), 0, 0)
end

function CInvtProperties:update_inventory(pIvtItems)
    local m_pInvtPlayer = self.pInvtPlayer

    local iPx, iPy = m_pInvtPlayer:get_origin()
    m_pInvtPlayer:load(pIvtItems, iPx, iPy)
end

function CInvtProperties:get_inventory()
    return self.pInvtPlayer
end

function CInvtProperties:set_inventory_origin(iPx, iPy)
    self.pInvtPlayer:set_origin(iPx, iPy)
end
