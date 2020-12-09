--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("solver.lookup.category.item")
require("solver.lookup.category.mob")

function solver_resource_lookup_init(pLandscape, ctLoots, ctMobs, ctReactors)
    local pLookupMobTab = init_lookup_category_mob_table(ctLoots, ctMobs, pLandscape)
    local pLookupItemTab = init_lookup_category_item_table(ctLoots, ctMobs, ctReactors, pLandscape)

    local pLookupTable = CSolverLookupTable:new({pMobs = pLookupMobTab, pItems = pLookupItemTab})
    return pLookupTable
end
