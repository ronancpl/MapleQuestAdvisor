--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("composer.containers.fields.field_distance_table")
require("router.procedures.world.distance")
require("router.procedures.world.outline")
require("router.structs.landscape.region")
require("utils.procedure.unpack")
require("utils.struct.class")

CFieldLandscape = createClass({
    tFieldRegions
})

function CFieldLandscape:_append_region_areas(pRegionAreasSet)
    local m_tFieldRegions = self.tFieldRegions

    local pRegion = CFieldRegion:new({pMapidsSet = pRegionAreasSet})
    table.insert(m_tFieldRegions, pRegion)
end

function CFieldLandscape:scan_region_areas(ctFieldsDist, ctFieldsMeta)
    self.tFieldRegions = {}

    local rgpRegionAreasSet = fetch_regional_areas(ctFieldsDist, ctFieldsMeta)
    for _, pAreasSet in ipairs(rgpRegionAreasSet) do
        self:_append_region_areas(pAreasSet)
    end
end

function CFieldLandscape:calc_land_distances(ctFieldsDist)
    local m_tFieldRegions = self.tFieldRegions

    for _, pRegion in ipairs(m_tFieldRegions) do
        local pRegionAreasSet = pRegion:get_areas()
        find_region_distances(pRegionAreasSet, ctFieldsDist)
    end
end
