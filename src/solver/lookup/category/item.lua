--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("solver.lookup.category")
require("solver.lookup.category.loot.fields")
require("solver.lookup.category.loot.tables")
require("solver.lookup.constant")

local function install_lookup_category_entries(pLookupTab, tpEntries, rgiRscids, ctItems, pLandscape)
    local fn_item_fields = fn_get_item_fields(ctItems)

    local tpFilteredEntries = filter_resource_table_entries(tpEntries, rgiRscids)
    pLookupTab:init(tpFilteredEntries, fn_item_fields, pLandscape, false)
end

function init_lookup_category_item_table(ctLoots, ctMobs, ctReactors, pLandscape, rgiRscids)
    local pLookupTab = CSolverLookupCategory:new({iTabId = RLookupCategory.ITEMS})

    install_lookup_category_entries(pLookupTab, ctLoots:get_mob_entries(), rgiRscids, ctMobs, pLandscape)
    install_lookup_category_entries(pLookupTab, ctLoots:get_reactor_entries(), rgiRscids, ctReactors, pLandscape)

    return pLookupTab
end
