--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("solver.lookup.category.entries.fields")
require("solver.lookup.category.entries.tables")

function install_lookup_category_entries_item(pLookupTab, trgpEntries, rgiRscids, ctItems, pLandscape)
    local fn_rsc_item_fields = fn_get_item_fields(ctItems)

    local tpFilteredEntries = filter_resource_table_entries(trgpEntries, rgiRscids)
    pLookupTab:init(tpFilteredEntries, fn_rsc_item_fields, pLandscape, false)
end

function install_lookup_category_entries_mob(pLookupTab, trgpEntries, rgiRscids, ctMobs, ctMobsGroup, pLandscape)
    local fn_rsc_item_fields = fn_get_mob_fields(ctMobsGroup, ctMobs)

    local tpFilteredEntries = filter_resource_table_entries(trgpEntries, rgiRscids)
    pLookupTab:init(tpFilteredEntries, fn_rsc_item_fields, pLandscape, false)
end

function install_lookup_category_entries_static(pLookupTab, trgpEntries, pLandscape, rgiRscids)
    local fn_rsc_static_fields = fn_get_static_fields()

    local tpFilteredEntries = filter_resource_table_entries(trgpEntries, rgiRscids)
    pLookupTab:init(tpFilteredEntries, fn_rsc_static_fields, pLandscape, true)
end
