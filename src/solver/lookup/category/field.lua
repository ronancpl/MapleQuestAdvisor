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

local function add_lookup_entry_if_exists(fn_get_lookup_entry, tpEntries, pEntry)
    local iSrcid
    local tpRscLoots
    iSrcid, tpRscLoots = fn_get_lookup_entry(pEntry)

    if iSrcid > -1 then
        tpEntries[iSrcid] = tpRscLoots
    end
end

local function fn_get_lookup_entry_field_enter(pQuestProp)
    local iSrcid = pQuestProp:get_requirement():get_field_enter()

    local tpRscLoots = {}
    tpRscLoots[iSrcid] = 1

    return iSrcid, tpRscLoots
end

local function fetch_lookup_entries_field_enter(ctQuests)
    local tpEntries = {}

    for _, pQuest in ipairs(ctQuests:get_quests()) do
        add_lookup_entry_if_exists(fn_get_lookup_entry_field_enter, tpEntries, pQuest:get_start())
        add_lookup_entry_if_exists(fn_get_lookup_entry_field_enter, tpEntries, pQuest:get_end())
    end

    return tpEntries
end

local function fetch_lookup_entry_field_npc(ctNpcs)
    local rgiNpcids = ctNpcs:get_keys()

    local trgiFieldNpcs = {}
    for _, iNpcid in ipairs(rgiNpcids) do
        local rgiMapids = ctNpcs:get_locations(iNpcid)
        for _, iMapid in ipairs(rgiMapids) do
            local rgiNpcs = trgiFieldNpcs[iMapid]
            if rgiNpcs == nil then
                rgiNpcs = {}
                trgiFieldNpcs[iMapid] = rgiNpcs
            end

            table.insert(rgiNpcs, iNpcid)
        end
    end

    return trgiFieldNpcs
end

local function fn_get_lookup_entry_field_npc(pEntry)
    local iSrcid = pEntry["field"]
    local rgiNpcs = pEntry["npcs"]

    local tiFieldNpcs = {}
    for _, iMapid in ipairs(rgiNpcs) do
        tiFieldNpcs[iMapid] = 1
    end

    return iSrcid, tiFieldNpcs
end

local function create_descriptor_field_npc_entry(iMapid, rgiNpcs)
    local pEntry = {}
    pEntry["field"] = iMapid
    pEntry["npcs"] = rgiNpcs

    return pEntry
end

local function fetch_lookup_entries_field_npc(ctNpcs)
    local trgiFieldNpcs = fetch_lookup_entry_field_npc(ctNpcs)
    local rgiFields = keys(trgiFieldNpcs)

    local tpEntries = {}
    for _, iMapid in ipairs(rgiFields) do
        local pEntry = create_descriptor_field_npc_entry(iMapid, trgiFieldNpcs[iMapid])
        add_lookup_entry_if_exists(fn_get_lookup_entry_field_npc, tpEntries, pEntry)
    end

    return tpEntries
end

local function install_lookup_category_entries(pLookupTab, tpEntries, pLandscape)
    local fn_static_fields = fn_get_static_fields()
    pLookupTab:init(tpEntries, fn_static_fields, pLandscape, true)
end

function init_lookup_category_field_enter_table(ctQuests, pLandscape)
    local pLookupTab = CSolverLookupCategory:new({iTabId = RLookupCategory.FIELD_ENTER})

    local tpEntries = fetch_lookup_entries(ctQuests)
    install_lookup_category_entries(pLookupTab, tpEntries, pLandscape)

    return pLookupTab
end

function init_lookup_category_field_npc_table(ctNpcs, pLandscape)
    local pLookupTab = CSolverLookupCategory:new({iTabId = RLookupCategory.FIELD_NPC})

    local tpEntries = fetch_lookup_entries_field_npc(ctNpcs)
    install_lookup_category_entries(pLookupTab, tpEntries, pLandscape)

    return pLookupTab
end
