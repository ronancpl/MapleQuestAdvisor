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
require("solver.lookup.category.entries.resources.static")
require("solver.lookup.constant")

local function add_lookup_entry_if_exists(fn_get_lookup_entry, trgpEntries, pEntry)
    local iRscid
    local rgpLoots
    iRscid, rgpLoots = fn_get_lookup_entry(pEntry)

    if iRscid > -1 then
        trgpEntries[iRscid] = rgpLoots
    end
end

local function fn_get_lookup_entry_field_enter(pQuestProp)
    local iRscid = pQuestProp:get_requirement():get_field_enter()
    local rgpLoots = {iRscid}

    return iRscid, rgpLoots
end

local function fetch_lookup_entries_field_enter(ctQuests)
    local trgpEntries = {}

    for _, pQuest in ipairs(ctQuests:get_quests()) do
        add_lookup_entry_if_exists(fn_get_lookup_entry_field_enter, trgpEntries, pQuest:get_start())
        add_lookup_entry_if_exists(fn_get_lookup_entry_field_enter, trgpEntries, pQuest:get_end())
    end

    return trgpEntries
end

function init_lookup_category_field_enter_table(ctQuests, pLandscape, rgiRscids)
    local pLookupTab = CSolverLookupCategory:new({iTabId = RLookupCategory.FIELD_ENTER})

    local trgpEntries = fetch_lookup_entries_field_enter(ctQuests)

    install_lookup_category_entries_static(pLookupTab, trgpEntries, rgiRscids)
    locate_lookup_category_entries_static(pLookupTab, pLandscape)
    array_lookup_category_entries_item(pLookupTab)

    return pLookupTab
end

local function fetch_lookup_entry_npc_fields(rgiRscids)
    local rgiRscMapids = rgiRscids

    local trgiNpcFields = {}
    for _, iMapid in ipairs(rgiRscMapids) do
        local rgiMapids = {}
        table.insert(rgiMapids, iMapid)

        trgiNpcFields[iMapid] = rgiMapids
    end

    return trgiNpcFields
end

local function fn_get_lookup_entry_npc_fields(pEntry)
    local iRscid = pEntry["field_npc"]
    local rgiFields = pEntry["fields"]

    return iRscid, rgiFields
end

local function create_descriptor_npc_fields_entry(iMapid, rgiFields)
    local pEntry = {}
    pEntry["field_npc"] = iMapid
    pEntry["fields"] = rgiFields

    return pEntry
end

local function fetch_lookup_entries_field_npc(rgiRscids)
    local trgiFields = fetch_lookup_entry_npc_fields(rgiRscids)
    local rgiFields = keys(trgiFields)

    local trgpEntries = {}
    for _, iMapid in ipairs(rgiFields) do
        local pEntry = create_descriptor_npc_fields_entry(iMapid, trgiFields[iMapid])
        add_lookup_entry_if_exists(fn_get_lookup_entry_npc_fields, trgpEntries, pEntry)
    end

    return trgpEntries
end

function init_lookup_category_field_npc_table(pLandscape, rgiRscids)
    local pLookupTab = CSolverLookupCategory:new({iTabId = RLookupCategory.FIELD_NPC})

    local trgpEntries = fetch_lookup_entries_field_npc(rgiRscids)

    install_lookup_category_entries_static(pLookupTab, trgpEntries, rgiRscids)
    locate_lookup_category_entries_static(pLookupTab, pLandscape)
    array_lookup_category_entries_item(pLookupTab)

    return pLookupTab
end
