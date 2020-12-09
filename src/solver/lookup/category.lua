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
    tRscItems = {},
    tRscRegionFields = {}
})

function CSolverLookupCategory:_init_entries(tpEntries)
    local m_tRscItems = self.tRscItems

    for iSrcid, rgpLoots in pairs(tpEntries) do
        for _, pLoot in ipairs(rgpLoots) do
            local iLootid = pLoot:get_sourceid()
            local rgiLootRscs = m_tRscItems[iLootid]

            if rgiLootRscs == nil then
                rgiLootRscs = {}
                m_tRscItems[iLootid] = rgiLootRscs
            end

            table.insert(rgiLootRscs, iSrcid)
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

        for _, iMapid in ipairs(fn_get_rsc_fields(m_tRscItems, iRscid)) do
            local iRegionid = pLandscape:get_region_by_mapid(iMapid)

            local rgiRscFields = trgiRegionFields[iRegionid]
            if rgiRscFields == nil then
                rgiRscFields = {}
                trgiRegionFields[iRegionid] = rgiRscFields
            end

            table.insert(rgiRscFields, iMapid)
        end
    end
end

function CSolverLookupCategory:init(tpEntries, fn_get_rsc_fields, pLandscape)
    self:_init_entries(tpEntries)
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
