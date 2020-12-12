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
require("solver.lookup.category.loot.fields")
require("solver.lookup.constant")

local function install_lookup_category_entries(pLookupTab, tpEntries, pLandscape)
    local fn_item_fields = fn_get_static_fields()
    pLookupTab:init(tpEntries, fn_item_fields, pLandscape)
end

function init_lookup_category_field_enter_table(iFieldEnter, pLandscape)
    local pLookupTab = CSolverLookupCategory:new({iTabId = RLookupCategory.FIELD_ENTER})

    local tpEntries = {}
    tpEntries[iFieldEnter] = iFieldEnter

    install_lookup_category_entries(pLookupTab, tpEntries, pLandscape)

    return pLookupTab
end

function init_lookup_category_field_npc_table(iFieldNpc, pLandscape)
    local pLookupTab = CSolverLookupCategory:new({iTabId = RLookupCategory.FIELD_NPC})

    local tpEntries = {}
    tpEntries[iFieldNpc] = iFieldNpc

    install_lookup_category_entries(pLookupTab, tpEntries, pLandscape)

    return pLookupTab
end
