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

function list_resources_from_entries_inventory(tiEntries)
    return keys(tiEntries)
end

function list_resources_from_entries_unit(iItemid)
    return {iItemid}
end

function filter_resource_table_entries(tpEntries, rgiResources)
    local tpFilteredEntries = {}

    for _, iRscid in ipairs(rgiResources) do
        local rgpLoots = tpEntries[iRscid]
        tpFilteredEntries[iRscid] = rgpLoots
    end

    return tpFilteredEntries
end

