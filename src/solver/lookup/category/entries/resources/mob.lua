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

function install_lookup_category_entries_mob(pLookupTab, trgpEntries, rgiRscids)
    local tpFilteredEntries = filter_resource_table_entries(trgpEntries, rgiRscids)
    pLookupTab:init(tpFilteredEntries, false)
end

function locate_lookup_category_entries_mob(pLookupTab, ctMobs, ctMobsGroup, pLandscape)
    local fn_src_item_fields = fn_get_mob_fields(ctMobsGroup, ctMobs)
    pLookupTab:locate(fn_src_item_fields, pLandscape, false)
end

function array_lookup_category_entries_mob(pLookupTab)
    pLookupTab:array()
end

function regional_lookup_category_entries_mob(pLookupTab)
    pLookupTab:regionalize()
end
