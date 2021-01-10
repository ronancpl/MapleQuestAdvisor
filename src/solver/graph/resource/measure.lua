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
require("solver.graph.resource.retrieve.item")
require("solver.lookup.constant")

function calc_resource_retrieve_utility_cost(ctFieldsLandscape, ctRetrieveLootMobs, ctRetrieveLootReactors, iEntryMapid, iRscid)
    local iRscType = math.floor(iRscid / 1000000000)
    local iRscUnit = iRscid % 1000000000

    local iRscUtilCost = 0.0
    if iRscType == RLookupCategory.ITEMS then
        iRscUtilCost = calc_resource_retrieve_cost_item(ctFieldsLandscape, ctRetrieveLootMobs, ctRetrieveLootReactors, iEntryMapid, iRscUnit)
    end

    return iRscUtilCost
end

function calc_resource_field_cost(iFieldDist)
    local fDistCost = math.clamp(iFieldDist, 0, 100) / 100  -- assumption: to make up for 100% chance, 100 maps traversed

    local iRscDistCost = math.sin(fDistCost * (math.pi / 2))
    return iRscDistCost
end

function calc_resource_retrieve_cost(iRscUtilCost, iRscDistCost)
    return iRscUtilCost + iRscDistCost
end
