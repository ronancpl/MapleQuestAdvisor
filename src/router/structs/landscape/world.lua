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
    rgpRegionFields = {},
    tiFieldRegion = {},
    tWorldNodes = {}
})

function CFieldLandscape:_append_region_areas(pRegionAreasSet)
    local m_rgpRegionFields = self.rgpRegionFields

    local pRegion = CFieldRegion:new({pMapidsSet = pRegionAreasSet})
    table.insert(m_tFieldRegions, pRegion)
end

function CFieldLandscape:scan_region_areas(ctFieldsDist, ctFieldsMeta)
    local rgpRegionAreasSet = fetch_regional_areas(ctFieldsDist, ctFieldsMeta)
    for _, pAreasSet in ipairs(rgpRegionAreasSet) do
        self:_append_region_areas(pAreasSet)
    end
end

function CFieldLandscape:make_index_area_region()    -- builds inverted index for region areas
    local m_rgpRegionFields = self.rgpRegionFields

    local m_tiFieldRegion = self.tiFieldRegion
    for iRegionid, pRegion in pairs(m_rgpRegionFields) do
        for _, iMapid in ipairs(pRegion:get_areas()) do
            m_tiFieldRegion[iMapid] = iRegionid
        end
    end
end

function CFieldLandscape:calc_region_distances(ctFieldsDist)
    local m_rgpRegionFields = self.rgpRegionFields

    for _, pRegion in ipairs(m_rgpRegionFields) do
        local pRegionAreasSet = pRegion:get_areas()
        find_region_distances(pRegionAreasSet, ctFieldsDist)
    end
end

function CFieldLandscape:_get_region_by_mapid(iMapid)
    local m_tiFieldRegion = self.tiFieldRegion
    return m_tiFieldRegion[iMapid]
end

function CFieldLandscape:_init_world_nodes()
    local m_tWorldNodes = self.tWorldNodes

    local m_rgpRegionFields = self.rgpRegionFields
    for iRegionId, _ in ipairs(m_rgpRegionFields) do
        m_tWorldNodes[iRegionId] = {}
    end
end

function CFieldLandscape:_build_world_nodes(ctStationsDist)
    local m_tWorldNodes = self.tWorldNodes

    for iSrcMapid, rgiDestMapids in pairs(tpRegionLinks) do
        local iSrcRegionId = self:_get_region_by_mapid(iSrcMapid)
        for _, iDestMapid in ipairs(rgiDestMapids) do
            local iDestRegionId = self:_get_region_by_mapid(iDestMapid)
            m_tWorldNodes[iSrcRegionId][iDestRegionId] = 1
        end
    end
end

function CFieldLandscape:build_interconnection_overworld(ctStationsDist)
    self:_init_world_nodes()
    self:_build_world_nodes(ctStationsDist)
end

