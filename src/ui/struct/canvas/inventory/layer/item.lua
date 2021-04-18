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

CInventoryNavItems = createClass({CWndLayer, {}})

function CInventoryNavItems:_build_element(pPropInvt)
    self:add_element(LChannel.INVT_ITEMS, pPropInvt)
end

function CInventoryNavItems:build(pInvtProp)
    self:reset()

    -- add layer elements

    local pInvt = pInvtProp:get_inventory()
    self:_build_element(pInvt)
end
