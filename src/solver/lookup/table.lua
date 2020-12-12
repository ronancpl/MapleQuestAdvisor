--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("solver.lookup.category")
require("utils.procedure.unpack")
require("utils.struct.class")

CSolverLookupTable = createClass({
    rgpTables = {}
})

function CSolverLookupTable:init_tables(rgpTables)
    local m_rgpTables = self.rgpTables

    local nTables = #m_rgpTables
    for i = 1, nTables, 1 do
        m_rgpTables[i] = nil
    end

    for _, pTable in ipairs(rgpTables) do
        table.insert(m_rgpTables, pTable)
    end
end

function CSolverLookupTable:_fetch_resources_fields(iRegionid)
    local tResourceFields = {}

    local m_rgpTables = self.rgpTables
    for _, pTable in ipairs(m_rgpTables) do
        for iRscid, rgiMapids in pairs(pTable:get_resource_fields(iRegionid)) do
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
    for iRscid, tRscMapids in pairs(tResourceFields) do
        tResourceFields[iRscid] = keys(tRscMapids)
    end
end

function CSolverLookupTable:get_resource_fields(iRegionid)
    local tResourceFields = self:_fetch_resources_fields(iRegionid)
    self:_list_resource_fields(tResourceFields)

    return tResourceFields
end
