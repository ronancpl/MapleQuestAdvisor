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
require("router.procedures.world.abroad")
require("router.procedures.world.outline")
require("router.procedures.world.regional")
require("router.structs.landscape.region")
require("utils.procedure.unpack")
require("utils.struct.class")

CFieldLandscape = createClass({
    rgpRegionFields = {},
    tiFieldRegion = {},
    tWorldNodes = {}
})

function CFieldLandscape:_append_region_areas(pSetRegionAreas)
    local m_rgpRegionFields = self.rgpRegionFields

    local pRegion = CFieldRegion:new({pSetMapids = pSetRegionAreas})
    table.insert(m_tFieldRegions, pRegion)
end

function CFieldLandscape:scan_region_areas(ctFieldsDist, ctFieldsMeta)
    local rgpSetRegionAreas = fetch_regional_areas(ctFieldsDist, ctFieldsMeta)
    for _, pSetAreas in ipairs(rgpSetRegionAreas) do
        self:_append_region_areas(pSetAreas)
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
        local pSetRegionAreas = pRegion:get_areas()
        find_region_distances(pSetRegionAreas, ctFieldsDist)
    end
end

function CFieldLandscape:get_region_count()
    local m_rgpRegionFields = self.rgpRegionFields
    return #m_rgpRegionFields
end

function CFieldLandscape:get_region_by_mapid(iMapid)
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

function CFieldLandscape:_build_world_nodes()
    local m_tWorldNodes = self.tWorldNodes

    for iSrcMapid, rgiDestMapids in pairs(tpRegionLinks) do
        local iSrcRegionId = self:get_region_by_mapid(iSrcMapid)
        for _, iDestMapid in ipairs(rgiDestMapids) do
            local iDestRegionId = self:get_region_by_mapid(iDestMapid)
            m_tWorldNodes[iSrcRegionId][iDestRegionId] = 1
        end
    end
end

function CFieldLandscape:build_interconnection_overworld()
    self:_init_world_nodes()
    self:_build_world_nodes()
end

function CFieldLandscape:calc_interregion_town_distances(ctFieldsDist, ctFieldsMeta, ctFieldsLink)
    local m_tiFieldRegion = self.tiFieldRegion
    local m_tWorldNodes = self.tWorldNodes

    fetch_interregional_town_distances(ctFieldsDist, ctFieldsMeta, ctFieldsLink, m_tiFieldRegion, m_tWorldNodes)
end
