--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("solver.lookup.category.field")
require("solver.lookup.category.item")
require("solver.lookup.category.mob")
require("solver.lookup.constant")
require("solver.lookup.table")

local function fetch_lookup_resources(pLandscape, ctLoots, ctMobs, ctMobsGroup, ctReactors, ctQuests, pLookupRscs)
    local rgiRscids
    local rgpCategoryTables = {}

    rgiRscids = pLookupRscs[RLookupCategory.MOBS]
    local pLookupMobTab = init_lookup_category_mob_table(ctLoots, ctMobs, ctMobsGroup, pLandscape, rgiRscids)
    table.insert(rgpCategoryTables, pLookupMobTab)

    rgiRscids = pLookupRscs[RLookupCategory.ITEMS]
    local pLookupItemTab = init_lookup_category_item_table(ctLoots, ctMobs, ctReactors, pLandscape, rgiRscids)
    table.insert(rgpCategoryTables, pLookupItemTab)

    rgiRscids = pLookupRscs[RLookupCategory.FIELD_ENTER]
    local pLookupFieldEnterTab = init_lookup_category_field_enter_table(ctQuests, pLandscape, rgiRscids)
    table.insert(rgpCategoryTables, pLookupFieldEnterTab)

    rgiRscids = pLookupRscs[RLookupCategory.FIELD_NPC]
    local pLookupFieldNpcTab = init_lookup_category_field_npc_table(pLandscape, rgiRscids)
    table.insert(rgpCategoryTables, pLookupFieldNpcTab)

    return rgpCategoryTables
end

function load_solver_resource_lookup(pLandscape, ctLoots, ctMobs, ctMobsGroup, ctReactors, ctQuests, pLookupRscs)
    local rgpCategoryTables = fetch_lookup_resources(pLandscape, ctLoots, ctMobs, ctMobsGroup, ctReactors, ctQuests, pLookupRscs)

    local pSolverLookup = CSolverLookupTable:new()
    pSolverLookup:init_tables(rgpCategoryTables)

    return pSolverLookup
end
