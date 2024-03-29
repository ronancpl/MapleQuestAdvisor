--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("solver.lookup.category")
require("utils.procedure.unpack")
require("utils.struct.class")
require("utils.struct.table")

CSolverLookupTable = createClass({
    rgpLookupTabs = {},
    tpRegionalFields = {}
})

function CSolverLookupTable:init_tables(rgpLookupTabs)
    local m_rgpLookupTabs = self.rgpLookupTabs

    clear_table(m_rgpLookupTabs)

    for _, pLookupTab in ipairs(rgpLookupTabs) do
        table.insert(m_rgpLookupTabs, pLookupTab)
    end
end

function CSolverLookupTable:_fetch_resources_fields(iRegionid)
    local tResourceFields = {}

    local m_rgpLookupTabs = self.rgpLookupTabs
    for _, pLookupTab in ipairs(m_rgpLookupTabs) do
        local trgiRscFields = pLookupTab:get_resource_fields(iRegionid)

        for iRscid, rgiMapids in pairs(trgiRscFields) do
            local tRscMapids = {}
            tResourceFields[iRscid] = tRscMapids

            for _, iMapid in ipairs(rgiMapids) do
                tRscMapids[iMapid] = 1
            end
        end
    end

    return tResourceFields
end

function CSolverLookupTable:_list_resource_fields(tResourceFields)
    local trgiRscFields = {}
    for iRscid, tRscMapids in pairs(tResourceFields) do
        trgiRscFields[iRscid] = keys(tRscMapids)
    end

    return trgiRscFields
end

function CSolverLookupTable:get_resource_fields(iRegionid)
    local m_tpRegionalFields = self.tpRegionalFields

    local tResourceFields = m_tpRegionalFields[iRegionid]
    if tResourceFields == nil then
        tResourceFields = self:_fetch_resources_fields(iRegionid)
        tResourceFields = self:_list_resource_fields(tResourceFields)

        m_tpRegionalFields[iRegionid] = tResourceFields
    end

    return tResourceFields
end

function CSolverLookupTable:get_resource_regions()
    local tResourceRegions = STable:new()

    local m_rgpLookupTabs = self.rgpLookupTabs
    for _, pLookupTab in ipairs(m_rgpLookupTabs) do
        local tTabResourceRegions = pLookupTab:get_resource_regions()
        tResourceRegions:insert_table(tTabResourceRegions)
    end

    return tResourceRegions:get_entry_set()
end

function CSolverLookupTable:debug_lookup_table()
    local m_rgpLookupTabs = self.rgpLookupTabs

    local rgpTabs = {"MOBS", "ITEMS", "FIELD_ENTER", "NPC"}

    local i = 1
    for _, pLookupTab in ipairs(m_rgpLookupTabs) do
        log(LPath.PROCEDURES, "resources_lookup.txt", " ==== LOOKUP " .. rgpTabs[i] .. " ====")
        pLookupTab:debug_resources()
        log(LPath.PROCEDURES, "resources_lookup.txt", "  =================================== ")
        log(LPath.PROCEDURES, "resources_lookup.txt", "")

        i = i + 1
    end
end
