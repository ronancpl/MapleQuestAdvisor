--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

function fetch_area_neighbors(rgpAreas, ctFieldsDist)
    local trgiNeighborMapids = {}

    for _, iMapid in pairs(rgpAreas) do
        local rgiNeighborMapids = {}
        trgiNeighborMapids[iMapid] = rgiNeighborMapids

        for iMapid, _ in pairs(ctFieldsDist:get_field_distances(iSrcid)) do
            table.insert(rgiNeighborMapids, iMapid)
        end
    end

    return trgiNeighborMapids
end

function apply_area_distances(ctFieldsDist, rgpAreas, ttiDistances)
    for iMapidA in pairs(rgpAreas) do
        for iMapidB in pairs(rgpAreas) do
            local iDist = ttiDistances[iMapidA][iMapidB]
            if iDist < U_INT_MAX then
                ctFieldsDist:add_field_distance(iMapidA, iMapidB, iDist)
            end
        end
    end
end
