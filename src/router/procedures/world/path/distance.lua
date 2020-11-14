--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("utils.procedure.constants")

local function init_distance_table(rgiMapids, trgiNeighborMapids)
    local ttiDistances = {}

    for _, iMapid in pairs(rgiMapids) do
        local tiAreaDistances = {}
        ttiDistances[iMapid] = tiAreaDistances

        for _, iMapid in pairs(rgiMapids) do
            tiAreaDistances[iMapid] = U_INT_MAX
        end

        tiAreaDistances[iMapid] = 0     -- self area
        for _, iMapid in ipairs(trgiNeighborMapids[iMapid]) do
            tiAreaDistances[iMapid] = 1   -- neighbor area
        end
    end

    return ttiDistances
end

function determine_distances(rgiMapids, trgiNeighborMapids)
    local ttiDistances = init_distance_table(rgiMapids, trgiNeighborMapids)

    for iMapidA in pairs(rgpAreas) do
        for iMapidB in pairs(rgpAreas) do
            for iMapidC in pairs(rgpAreas) do
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
