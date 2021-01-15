--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("solver.graph.resource.table.loots")

function calc_resource_retrieve_cost_item(ctFieldsLandscape, ctRetrieveLootMobs, ctRetrieveLootReactors, iEntryMapid, iRscid)
    local iEntryRegionid = ctFieldsLandscape:get_region_by_mapid(iEntryMapid)

    local fChanceMob = ctRetrieveLootMobs:get_acquisition_chance(iRscid, iEntryRegionid)
    local fChanceReactor = ctRetrieveLootReactors:get_acquisition_chance(iRscid, iEntryRegionid)
    local fChance = math.max(fChanceMob, fChanceReactor)

    return math.sin((1.0 - fChance) * (math.pi / 2))
end
