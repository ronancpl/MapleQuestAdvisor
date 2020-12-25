--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("utils.struct.class")
require("utils.procedure.unpack")

CSolverLookupCategory = createClass({
    iTabId = 0,
    tRscItems = {},
    tRegionRscFields = {}
})

function CSolverLookupCategory:_get_tab_resource_id(iRscid)
    return (self.iTabId * 1000000000) + iRscid
end

function CSolverLookupCategory:_reset_entries()
    local m_tRscItems = self.tRscItems
    clear_table(m_tRscItems)

    local m_tRegionRscFields = self.tRegionRscFields
    clear_table(m_tRegionRscFields)
end

function CSolverLookupCategory:_init_entries(trgpEntries, fn_get_rscid)
    local m_tRscItems = self.tRscItems

    for iSrcid, rgpRscLoots in pairs(trgpEntries) do
        for _, pLoot in ipairs(rgpRscLoots) do
            local iRscid = fn_get_rscid(pLoot)

            local rgiSrcids = m_tRscItems[iRscid]
            if rgiSrcids == nil then
                rgiSrcids = {}
                m_tRscItems[iRscid] = rgiSrcids
            end

            table.insert(rgiSrcids, iSrcid)
        end
    end
end

function CSolverLookupCategory:_fetch_resource_regions(pLandscape, rgiFields)
    local trgiRegionFields = {}

    for _, iMapid in ipairs(rgiFields) do
        local iRegionid = pLandscape:get_region_by_mapid(iMapid)

        local rgiFields = trgiRegionFields[iRegionid]
        if rgiFields == nil then
            rgiFields = {}
            trgiRegionFields[iRegionid] = rgiFields
        end

        table.insert(rgiFields, iMapid)
    end

    return trgiRegionFields
end

function CSolverLookupCategory:_locate_resources(pLandscape, fn_get_rsc_fields)
    local m_tRegionRscFields = self.tRegionRscFields
    local m_tRscItems = self.tRscItems

    for _, iRscid in ipairs(keys(m_tRscItems)) do
        local rgiFields = fn_get_rsc_fields(m_tRscItems, iRscid)

        for iRegionid, rgiMapids in pairs(self:_fetch_resource_regions(pLandscape, rgiFields)) do
            local trgiRegionRscs = m_tRegionRscFields[iRegionid]
            if trgiRegionRscs == nil then
                trgiRegionRscs = {}
                m_tRegionRscFields[iRegionid] = trgiRegionRscs
            end

            local rgiRegionRscFields = trgiRegionRscs[iRscid]
            if rgiRegionRscFields == nil then
                rgiRegionRscFields = {}
                trgiRegionRscs[iRscid] = rgiRegionRscFields
            end

            for _, iMapid in ipairs(rgiMapids) do
                table.insert(rgiRegionRscFields, iMapid)
            end
        end
    end
end

local function get_fn_rscid(bRscInt)
    local fn_get_rscid

    if bRscInt then
        fn_get_rscid = function(pRsc) return pRsc end
    else
        fn_get_rscid = function(pRsc) return pRsc:get_sourceid() end
    end

    return fn_get_rscid
end

function CSolverLookupCategory:init(trgpEntries, fn_get_rsc_fields, pLandscape, bRscInt)
    self:_reset_entries()

    self:_init_entries(trgpEntries, get_fn_rscid(bRscInt))
    self:_locate_resources(pLandscape, fn_get_rsc_fields)
end

function CSolverLookupCategory:get_resource_fields(iRegionid)
    local tResourceFields = {}

    local trgiRscFields = self.tRegionRscFields[iRegionid]
    if trgiRscFields ~= nil then
        for iRscid, rgiFields in pairs(trgiRscFields) do
            local iExtRscid = self:_get_tab_resource_id(iRscid)     -- differentiates from resources of other tables
            local rgiMapids = deep_copy(rgiFields)

            tResourceFields[iExtRscid] = rgiMapids
        end
    end

    return tResourceFields
end
