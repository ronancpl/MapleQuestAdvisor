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
require("solver.lookup.table")

function solver_resource_lookup_init(pLandscape, ctLoots, ctMobs, ctReactors, iFieldEnter, iFieldNpc)
    local rgpCategoryTables = {}

    local pLookupMobTab = init_lookup_category_mob_table(ctLoots, ctMobs, pLandscape)
    table.insert(rgpCategoryTables, pLookupMobTab)

    local pLookupItemTab = init_lookup_category_item_table(ctLoots, ctMobs, ctReactors, pLandscape)
    table.insert(rgpCategoryTables, pLookupItemTab)

    local pLookupFieldEnterTab = init_lookup_category_field_enter_table(iFieldEnter, pLandscape)
    table.insert(rgpCategoryTables, pLookupFieldEnterTab)

    --[[
    local pLookupFieldNpcTab = init_lookup_category_field_npc_table(iFieldNpc, pLandscape)
    table.insert(rgpCategoryTables, pLookupFieldNpcTab)
    ]]--

    local pLookupTable = CSolverLookupTable:new()
    pLookupTable:init_tables(rgpCategoryTables)

    return pLookupTable
end
