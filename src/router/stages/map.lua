--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("router.structs.landscape.world")

function load_regions_overworld(ctFieldsDist, ctFieldsMeta)
    ctFieldsLandscape = CFieldLandscape:new()
    ctFieldsLandscape:scan_region_areas(ctFieldsDist, ctFieldsMeta)
    ctFieldsLandscape:make_index_area_region()
end

function load_distances_overworld(ctFieldsLandscape, ctFieldsDist, ctFieldsMeta, ctStationsDist)
    ctFieldsLandscape:calc_region_distances(ctFieldsDist)   -- calc distance between each pair of same-region areas

    ctFieldsLandscape:build_interconnection_overworld(ctStationsDist)
    ctFieldsLandscape:calc_interregion_town_distances(ctFieldsDist, ctFieldsMeta)
end
