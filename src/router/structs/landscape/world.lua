--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

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
require("utils.logger.file")
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
    table.insert(m_rgpRegionFields, pRegion)
end

function CFieldLandscape:scan_region_areas(ctFieldsDist)
    local rgpSetRegionAreas = fetch_regional_areas(ctFieldsDist)
    for _, pSetAreas in ipairs(rgpSetRegionAreas) do
        self:_append_region_areas(pSetAreas)
    end
end

function CFieldLandscape:make_remissive_index_area_region()    -- builds inverted index for region areas
    local m_rgpRegionFields = self.rgpRegionFields

    local m_tiFieldRegion = self.tiFieldRegion
    for iRegionid, pRegion in pairs(m_rgpRegionFields) do
        for _, iMapid in ipairs(pRegion:get_areas()) do
            m_tiFieldRegion[iMapid] = iRegionid
        end
    end
end

function CFieldLandscape:get_field_regions()
    return self.tiFieldRegion
end

local function debug_region_areas(rgiRegionAreas, ctFieldsMeta)
    local str = ""
    for _, iMapid in pairs(rgiRegionAreas) do
        str = str .. ctFieldsMeta:get_area_name(iMapid) .. " | "
    end
    log(LPath.PROCEDURES, "log.txt", "[" .. str .. "]")
end

function CFieldLandscape:calc_region_distances(ctFieldsDist, ctFieldsMeta)
    local m_rgpRegionFields = self.rgpRegionFields

    for _, pRegion in ipairs(m_rgpRegionFields) do
        local rgiRegionAreas = pRegion:get_areas()

        if #rgiRegionAreas > 2 then
            log(LPath.PROCEDURES, "log.txt", "Load region #" .. _ .. " " .. #rgiRegionAreas)
            debug_region_areas(rgiRegionAreas, ctFieldsMeta)
            log(LPath.PROCEDURES, "log.txt", "")
        end

        find_region_distances(rgiRegionAreas, ctFieldsDist)
    end

    log(LPath.OVERALL, "log.txt", "Load regions finished.")
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

function CFieldLandscape:_build_world_nodes(ctFieldsLink)
    local m_tWorldNodes = self.tWorldNodes

    local tpRegionLinks = ctFieldsLink:get_hub_entries()
    for iSrcMapid, rgiDestMapids in pairs(tpRegionLinks) do
        local iSrcRegionId = self:get_region_by_mapid(iSrcMapid)
        for _, iDestMapid in ipairs(rgiDestMapids) do
            local iDestRegionId = self:get_region_by_mapid(iDestMapid)
            m_tWorldNodes[iSrcRegionId][iDestRegionId] = 1
        end
    end
end

function CFieldLandscape:get_world_nodes()
    return self.tWorldNodes
end

function CFieldLandscape:build_interconnection_overworld(ctFieldsLink)
    self:_init_world_nodes()
    self:_build_world_nodes(ctFieldsLink)
end

function CFieldLandscape:calc_interregion_town_distances(ctFieldsDist, ctFieldsMeta, ctFieldsWmap, ctFieldsLink)
    local m_tiFieldRegion = self.tiFieldRegion
    local m_tWorldNodes = self.tWorldNodes

    fetch_interregional_town_distances(ctFieldsDist, ctFieldsMeta, ctFieldsWmap, ctFieldsLink, m_tiFieldRegion, m_tWorldNodes)
    log(LPath.OVERALL, "log.txt", "Calc interregional town distance finished.")
end

function CFieldLandscape:fetch_field_distance(iSrcMapid, iDestMapid, ctFieldsDist, ctFieldsMeta, ctFieldsWmap, ctFieldsLink)
    local m_tiFieldRegion = self.tiFieldRegion
    local m_tWorldNodes = self.tWorldNodes

    local iDistance = fetch_map_distance(iSrcMapid, iDestMapid, ctFieldsDist, ctFieldsMeta, ctFieldsWmap, ctFieldsLink, m_tiFieldRegion, m_tWorldNodes)
    return iDistance
end
