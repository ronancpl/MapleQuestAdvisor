--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("ui.struct.window.summary")
require("ui.struct.window.frame.layer")
require("utils.struct.class")

CInventoryNavTable = createClass({CWndLayer, {}})

function CInventoryNavTable:_build_element(pElemInvt)
    self:add_element(LChannel.INVT_TABLE, pElemInvt)
end

function CInventoryNavTable:build(pInvtProp)
    self:reset()

    -- add layer elements

    local pElemInvt = pInvtProp:get_inventory()
    self:_build_element(pElemInvt)
end
