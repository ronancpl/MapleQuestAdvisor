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
require("solver.lookup.category.entries.resources.mob")
require("solver.lookup.constant")

function init_lookup_category_mob_table(ctLoots, ctMobs, ctMobsGroup, pLandscape, rgiRscids)
    local pLookupTab = CSolverLookupCategory:new({iTabId = RLookupCategory.MOBS})

    install_lookup_category_entries_mob(pLookupTab, ctLoots:get_loot_mob_entries(), rgiRscids)
    locate_lookup_category_entries_mob(pLookupTab, ctMobs, ctMobsGroup, pLandscape)
    array_lookup_category_entries_mob(pLookupTab)
    regional_lookup_category_entries_mob(pLookupTab)

    return pLookupTab
end
