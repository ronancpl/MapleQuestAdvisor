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

local function install_lookup_category_entries(pLookupTab, tpEntries, ctItems, pLandscape)
    local fn_item_fields = fn_get_item_fields(ctItems, tpEntries)
    pLookupTab:init(tpEntries, fn_item_fields, pLandscape)
end

function init_lookup_category_item_table(ctLoots, ctMobs, ctReactors, pLandscape)
    local pLookupTab = CSolverLookupCategory:new()

    install_lookup_category_entries(pLookupTab, ctLoots:get_mob_entries(), ctMobs)
    install_lookup_category_entries(pLookupTab, ctLoots:get_reactor_entries(), ctReactors)

    return pLookupTab
end
