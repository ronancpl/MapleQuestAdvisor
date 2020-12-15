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

local function init_distance_table(rgiMapids, trgiNeighborMapids)
    local ttiDistances = {}

    for _, iMapid in ipairs(rgiMapids) do
        local tiAreaDistances = {}
        ttiDistances[iMapid] = tiAreaDistances

        for _, iNeighborMapid in ipairs(rgiMapids) do
            tiAreaDistances[iNeighborMapid] = U_INT_MAX
        end

        tiAreaDistances[iMapid] = 0     -- self area
        for _, iNeighborMapid in ipairs(trgiNeighborMapids[iMapid]) do
            tiAreaDistances[iNeighborMapid] = 1   -- neighbor area
        end
    end

    return ttiDistances
end

function determine_distances(rgiMapids, trgiNeighborMapids)
    local ttiDistances = init_distance_table(rgiMapids, trgiNeighborMapids)

    for _, iMapidC in ipairs(rgiMapids) do
        for _, iMapidB in ipairs(rgiMapids) do
            for _, iMapidA in ipairs(rgiMapids) do
                local iCurDistAB = ttiDistances[iMapidA][iMapidB]
                local iCurDistAC = ttiDistances[iMapidA][iMapidC]
                local iCurDistCB = ttiDistances[iMapidC][iMapidB]

                local iDistAB = iCurDistAC + iCurDistCB
                if iCurDistAB > iDistAB then
                    ttiDistances[iMapidA][iMapidB] = iDistAB
                end
            end
        end
    end

    return ttiDistances
end
