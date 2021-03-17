--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("router.procedures.constant")

function fetch_area_neighbors(rgpAreas, ctFieldsDist)
    local trgiNeighborMapids = {}

    for _, iMapid in pairs(rgpAreas) do
        local rgiNeighborMapids = {}
        trgiNeighborMapids[iMapid] = rgiNeighborMapids

        for iNeighborMapid, _ in pairs(ctFieldsDist:get_field_distances(iMapid)) do
            table.insert(rgiNeighborMapids, iNeighborMapid)
        end
    end

    return trgiNeighborMapids
end

function apply_area_distances(ctFieldsDist, rgpAreas, ttiDistances)
    for _, iMapidA in ipairs(rgpAreas) do
        for _, iMapidB in ipairs(rgpAreas) do
            local iDist = ttiDistances[iMapidA][iMapidB]
            if iDist < U_INT_MAX then
                ctFieldsDist:add_field_distance(iMapidA, iMapidB, iDist)
            end
        end
    end
end
