--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("router.filters.constant")
require("solver.graph.resource.table.loots")

local function fn_get_loot_drop_chance_from_mob(pLoot)
    local fChance = pLoot:get_chance() / 999999
    return math.clamp(fChance, 0.0, 1.0)
end

local function fn_get_loot_drop_chance_from_reactor(pLoot)
    local fChance = 1 / math.clamp(pLoot:get_chance(), 0.0, U_INT_MAX)
    return fChance
end

local function create_acquisition_loot_table(iDropRate, fn_get_drop_chance, ctFieldsLandscape, ctFieldsMeta, ctLootSources, trgpLoots)
    local ctRetrieveLoots = CRetrieveItemTable:new()

    for _, rgpLoots in pairs(trgpLoots) do
        for _, pLoot in ipairs(rgpLoots) do
            ctRetrieveLoots:add_acquisition_loot(ctFieldsLandscape, ctFieldsMeta, ctLootSources, pLoot)
        end
    end

    ctRetrieveLoots:build_acquisition_loot_chances(iDropRate, fn_get_drop_chance)
    return ctRetrieveLoots
end

function load_acquisition_loot_table(iDropRate, ctFieldsLandscape, ctFieldsMeta, ctLoots)
    local ctRetrieveLootMobs = create_acquisition_loot_table(iDropRate, fn_get_loot_drop_chance_from_mob, ctFieldsLandscape, ctFieldsMeta, ctMobs, ctLoots:get_loot_mob_entries())
    local ctRetrieveLootReactors = create_acquisition_loot_table(iDropRate, fn_get_loot_drop_chance_from_reactor, ctFieldsLandscape, ctFieldsMeta, ctReactors, ctLoots:get_loot_reactor_entries())

    return ctRetrieveLootMobs, ctRetrieveLootReactors
end
