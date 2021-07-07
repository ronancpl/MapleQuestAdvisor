--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("solver.lookup.category")
require("solver.lookup.category.entries.resources.item")
require("solver.lookup.constant")

function init_lookup_category_item_table(ctLoots, ctMobs, ctReactors, pLandscape, rgiRscids)
    local pLookupTab = CSolverLookupCategory:new({iTabId = RLookupCategory.ITEMS})

    install_lookup_category_entries_item(pLookupTab, ctLoots:get_mob_entries(), rgiRscids)
    locate_lookup_category_entries_item(pLookupTab, ctMobs, pLandscape)

    install_lookup_category_entries_item(pLookupTab, ctLoots:get_reactor_entries(), rgiRscids)
    locate_lookup_category_entries_item(pLookupTab, ctReactors, pLandscape)

    array_lookup_category_entries_item(pLookupTab)
    regional_lookup_category_entries_item(pLookupTab)

    return pLookupTab
end
