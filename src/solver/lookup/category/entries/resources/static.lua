--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("solver.lookup.category.entries.fields")
require("solver.lookup.category.entries.tables")

function install_lookup_category_entries_static(pLookupTab, trgpEntries, rgiRscids)
    local tpFilteredEntries = filter_resource_table_entries(trgpEntries, rgiRscids)
    pLookupTab:init(tpFilteredEntries, true)
end

function locate_lookup_category_entries_static(pLookupTab, pLandscape)
    local fn_rsc_static_fields = fn_get_static_fields()
    pLookupTab:locate(fn_rsc_static_fields, pLandscape, nil)
end

function array_lookup_category_entries_static(pLookupTab)
    pLookupTab:array()
end

function regional_lookup_category_entries_static(pLookupTab)
    pLookupTab:regionalize()
end
