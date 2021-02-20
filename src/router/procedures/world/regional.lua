--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("router.procedures.world.path.distance")
require("router.procedures.world.path.table")

function find_region_distances(rgiRegionAreas, ctFieldsDist)
    local rgiRegionMapids = rgiRegionAreas
    local trgiRegionNeighborMapids = fetch_area_neighbors(rgiRegionMapids, ctFieldsDist)

    local ttiRegionDistances = determine_distances(rgiRegionMapids, trgiRegionNeighborMapids)
    apply_area_distances(ctFieldsDist, rgiRegionMapids, ttiRegionDistances)
end
