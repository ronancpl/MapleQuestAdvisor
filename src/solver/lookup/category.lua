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

CSolverLookupCategory = createClass({
    iTabId = 0,
    tRscItems = {},
    tRscRegionFields = {}
})

function CSolverLookupCategory:_get_tab_resource_id(iRscid)
    return (self.iTabId * 1000000000) + iRscid
end

function CSolverLookupCategory:_init_entries(tpEntries, fn_get_rscid)
    local m_tRscItems = self.tRscItems

    for iSrcid, tpRscLoots in pairs(tpEntries) do
        for iRscid, _ in pairs(tpRscLoots) do
            local rgiSrcids = m_tRscItems[iRscid]
            if rgiSrcids == nil then
                rgiSrcids = {}
                m_tRscItems[iRscid] = rgiSrcids
            end

            table.insert(rgiSrcids, iSrcid)
        end
    end
end

function CSolverLookupCategory:_locate_resources(pLandscape, tpEntries, fn_get_rsc_fields)
    local m_tRscRegionFields = self.tRscRegionFields
    local m_tRscItems = self.tRscItems

    for _, iRscid in ipairs(keys(tpEntries)) do
        local trgiRegionFields = m_tRscRegionFields[iRscid]
        if trgiRegionFields == nil then
            trgiRegionFields = {}
            m_tRscRegionFields[iRscid] = trgiRegionFields
        end

        for iRegionid, rgiMapids in pairs(fn_get_rsc_fields(m_tRscItems, iRscid)) do
            local rgiRscFields = trgiRegionFields[iRegionid]
            if rgiRscFields == nil then
                rgiRscFields = {}
                trgiRegionFields[iRegionid] = rgiRscFields
            end

            for _, iMapid in ipairs(rgiMapids) do
                table.insert(rgiRscFields, iMapid)
            end
        end
    end
end

function CSolverLookupCategory:init(tpEntries, fn_get_rsc_fields, pLandscape, bRscInt)
    if bRscInt then
        self:_init_entries(tpEntries, function(pRsc) return pRsc end)
    else
        self:_init_entries(tpEntries, function(pRsc) return pRsc:get_sourceid() end)
    end

    self:_locate_resources(pLandscape, tpEntries, fn_get_rsc_fields)
end

function CSolverLookupCategory:get_field_resources_by_region_id(iRegionid, ivtItems)
    local tpItems = ivtItems:get_items()

    local m_tRscRegionFields = self.tRscRegionFields
    local tRscFields = m_tRscRegionFields[iRegionid]

    local trgpFieldRscs = {}
    if tRscFields ~= nil then
        for iRscid, rgiMapids in pairs(tRscFields) do
            if tpItems[iRscid] ~= nil then
                for _, iMapid in ipairs(rgiMapids) do
                    local rgiFieldRscs = trgpFieldRscs[iMapid]
                    if rgiFieldRscs == nil then
                        rgiFieldRscs = {}
                        trgpFieldRscs[iMapid] = trgpFieldRscs[iMapid]
                    end

                    table.insert(rgiFieldRscs, iMapid)
                end
            end
        end
    end

    return trgpFieldRscs
end

function CSolverLookupCategory:get_resource_fields(iRegionid)
    local tResourceFields = {}

    local m_tRscRegionFields = self.tRscRegionFields
    for iRscid, tRegionFields in pairs(m_tRscRegionFields) do
        local iExtRscid = self:_get_tab_resource_id(iRscid)     -- differentiates from resources of other tables

        local rgiFields = {}
        tResourceFields[iExtRscid] = rgiFields

        if iRegionid ~= nil then
            local rgiMapids = tRegionFields[iRegionid]
            if rgiMapids ~= nil then
                for _, iMapid in ipairs(rgiMapids) do
                    table.insert(rgiFields, iMapid)
                end
            end
        else
            for _, rgiMapids in pairs(tRegionFields) do
                for _, iMapid in ipairs(rgiMapids) do
                    table.insert(rgiFields, iMapid)
                end
            end
        end
    end

    return tResourceFields
end
