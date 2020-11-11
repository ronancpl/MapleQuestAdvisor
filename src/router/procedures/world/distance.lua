--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

local U_INT_MAX = 0x7FFFFFFF

local function init_region_table(rgpRegionAreas, ctFieldsDist)
    local ttiRegionDistances = {}

    for _, iMapid in pairs(rgpRegionAreas) do
        local tiAreaDistances = {}
        ttiRegionDistances[iMapid] = tiAreaDistances

        for _, iMapid in pairs(rgpRegionAreas) do
            tiAreaDistances[iMapid] = U_INT_MAX
        end

        tiAreaDistances[iMapid] = 0     -- self area
        for iRegionMapid, _ in pairs(ctFieldsDist:get_field_distances(iSrcid)) do
            tiAreaDistances[iRegionMapid] = 1   -- neighbor area
        end
    end

    return ttiRegionDistances
end

local function trail_region_distances(rgpRegionAreas, ttiRegionDistances)
    for iMapidA in pairs(rgpRegionAreas) do
        for iMapidB in pairs(rgpRegionAreas) do
            for iMapidC in pairs(rgpRegionAreas) do
                local iCurDistAB = ttiRegionDistances[iMapidA][iMapidB]
                local iCurDistAC = ttiRegionDistances[iMapidA][iMapidC]
                local iCurDistCB = ttiRegionDistances[iMapidC][iMapidB]

                local iDistAB = iCurDistAC + iCurDistCB
                if iCurDistAB > iDistAB then
                    ttiRegionDistances[iMapidA][iMapidB] = iDistAB
                end
            end
        end
    end
end

local function apply_region_distances(ctFieldsDist, rgpRegionAreas, ttiRegionDistances)
    for iMapidA in pairs(rgpRegionAreas) do
        for iMapidB in pairs(rgpRegionAreas) do
            local iDist = ttiRegionDistances[iMapidA][iMapidB]
            if iDist < U_INT_MAX then
                ctFieldsDist:add_field_distance(iMapidA, iMapidB, iDist)
            end
        end
    end
end

function find_region_distances(pRegionAreasSet, ctFieldsDist)
    local rgpRegionAreas = pRegionAreasSet:values()

    local ttiRegionDistances = init_region_table(rgpRegionAreas, ctFieldsDist)
    trail_region_distances(rgpRegionAreas, ttiRegionDistances)

    apply_region_distances(ctFieldsDist, rgpRegionAreas, ttiRegionDistances)
end
