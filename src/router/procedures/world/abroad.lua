--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("router.procedures.world.path.distance")
require("router.procedures.world.path.table")

local function get_region_by_mapid(tiFieldRegion, iMapid)
    return tiFieldRegion[iMapid]
end

local function get_interregional_path(iSrcMapid, iDestMapid)

end

local function apply_town_distances(ctFieldsDist, rgpRegionAreas, ttiRegionDistances)
    for iMapidA in pairs(rgpRegionAreas) do
        for iMapidB in pairs(rgpRegionAreas) do
            local iDist = ttiRegionDistances[iMapidA][iMapidB]
            if iDist < U_INT_MAX then
                ctFieldsDist:add_field_distance(iMapidA, iMapidB, iDist)
            end
        end
    end
end

function fetch_interregional_town_distances(ctFieldsDist, ctFieldsMeta, tiFieldRegion, tWorldNodes)
    local rgiTownMapids = ctFieldsMeta:get_towns()
    local trgiNeighborMapids = fetch_area_neighbors(rgiTownMapids, ctFieldsDist)

    local ttiTownDistances = determine_distances(rgiTownMapids, trgiNeighborMapids) -- TODO this ain't a connected regional graph
    apply_area_distances(ctFieldsDist, rgiTownMapids, ttiTownDistances)
end
