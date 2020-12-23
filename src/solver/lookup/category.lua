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
    tRegionRscFields = {}
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
    local m_tRegionRscFields = self.tRegionRscFields
    local m_tRscItems = self.tRscItems

    for _, iRscid in ipairs(keys(tpEntries)) do
        for iRegionid, rgiMapids in pairs(fn_get_rsc_fields(m_tRscItems, iRscid)) do
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

function CSolverLookupCategory:init(tpEntries, fn_get_rsc_fields, pLandscape, bRscInt)
    local fn_get_rscid = get_fn_rscid(bRscInt)

    self:_init_entries(tpEntries, fn_get_rscid)
    self:_locate_resources(pLandscape, tpEntries, fn_get_rsc_fields)
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
