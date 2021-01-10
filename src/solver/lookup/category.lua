--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("utils.procedure.unpack")
require("utils.struct.class")

CSolverLookupCategory = createClass({
    iTabId = 0,
    tSrcItems = {},
    tRegionRscFields = {}
})

function CSolverLookupCategory:_get_tab_resource_id(iRscid)
    return (self.iTabId * 1000000000) + iRscid
end

function CSolverLookupCategory:_init_entries(trgpEntries, fn_get_srcid)
    local m_tSrcItems = self.tSrcItems
    clear_table(m_tSrcItems)

    for _, rgpSrcLoots in pairs(trgpEntries) do
        if #rgpSrcLoots > 0 then
            local pLoot = rgpSrcLoots[1]

            local iSrcid = fn_get_srcid(pLoot)
            m_tSrcItems[iSrcid] = deep_copy(rgpSrcLoots)
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

function CSolverLookupCategory:_locate_resource_fields(pLandscape, fn_get_rscid, fn_get_src_fields)
    local m_tRegionRscFields = self.tRegionRscFields
    local m_tSrcItems = self.tSrcItems

    for iSrcid, rgpItems in pairs(m_tSrcItems) do
        local rgiFields = fn_get_src_fields(m_tSrcItems, iSrcid)

        for iRegionid, rgiMapids in pairs(self:_fetch_resource_regions(pLandscape, rgiFields)) do
            for _, pItem in ipairs(rgpItems) do
                local iRscid = fn_get_rscid(pItem)

                local tpRegionRscs = m_tRegionRscFields[iRegionid]
                if tpRegionRscs == nil then
                    tpRegionRscs = {}
                    m_tRegionRscFields[iRegionid] = tpRegionRscs
                end

                local tRegionRscFields = tpRegionRscs[iRscid]
                if tRegionRscFields == nil then
                    tRegionRscFields = {}
                    tpRegionRscs[iRscid] = tRegionRscFields
                end

                for _, iMapid in ipairs(rgiMapids) do
                    tRegionRscFields[iMapid] = 1
                end
            end
        end
    end
end

function CSolverLookupCategory:_array_resource_fields()
    local m_tRegionRscFields = self.tRegionRscFields

    local tpRegionRscFields = {}

    for iRegionid, tpRegionRscs in pairs(m_tRegionRscFields) do
        local trgiRegionRscs = create_inner_table_if_not_exists(tpRegionRscFields, iRegionid)

        for iRscid, tRegionRscFields in pairs(tpRegionRscs) do
            local rgiMapids = keys(tRegionRscFields)
            trgiRegionRscs[iRscid] = rgiMapids
        end
    end

    for iRegionid, tpRegionRscs in pairs(tpRegionRscFields) do
        local trgiRegionRscs = m_tRegionRscFields[iRegionid]

        for iRscid, rgiMapids in pairs(tpRegionRscs) do
            trgiRegionRscs[iRscid] = rgiMapids
        end
    end
end

function CSolverLookupCategory:_locate_resources(pLandscape, fn_get_rscid, fn_get_src_fields)
    self:_locate_resource_fields(pLandscape, fn_get_rscid, fn_get_src_fields)
end

function CSolverLookupCategory:_array_resources()
    self:_array_resource_fields()
end

function CSolverLookupCategory:debug_resources()
    local m_tRegionRscFields = self.tRegionRscFields

    for iRegion, trgiRegionRscFields in pairs(m_tRegionRscFields) do
        if next(trgiRegionRscFields) ~= nil then
            print("REGIONAL #" .. iRegion)
            for iRscid, rgiRegionRscFields in pairs(trgiRegionRscFields) do
                local iRscUnit = iRscid % 1000000000

                local st = " -- {".. iRscUnit .. "} : ["
                for _, iMapid in ipairs(rgiRegionRscFields) do
                    st = st .. iMapid .. ", "
                end
                st = st .. "]"
                print(st)
            end
            print()
        end
    end

    print("---------")
end

local function get_fn_rscid(bRscInt)
    local fn_get_rscid

    if bRscInt then
        fn_get_rscid = function(pRsc) return pRsc end
    else
        fn_get_rscid = function(pRsc) return pRsc:get_itemid() end
    end

    return fn_get_rscid
end

local function get_fn_srcid(bRscInt)
    local fn_get_srcid

    if bRscInt then
        fn_get_srcid = function(pRsc) return pRsc end
    else
        fn_get_srcid = function(pRsc) return pRsc:get_sourceid() end
    end

    return fn_get_srcid
end

function CSolverLookupCategory:init(trgpEntries, bRscInt)
    self:_init_entries(trgpEntries, get_fn_srcid(bRscInt))
end

function CSolverLookupCategory:locate(fn_get_src_fields, pLandscape, bRscInt)
    self:_locate_resources(pLandscape, get_fn_rscid(bRscInt), fn_get_src_fields)
end

function CSolverLookupCategory:array()
    self:_array_resources()
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
