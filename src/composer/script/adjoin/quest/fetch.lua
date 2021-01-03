--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("composer.script.adjoin.util")
require("utils.procedure.unpack")

local function fetch_accessible_quests_map(sScriptName, tpFieldQuests)
    local fn_unit_key = fn_get_entry_key(false)
    local sMapScriptName = fn_unit_key(sScriptName)
    local rgiMapids = ctExMaps:get_locations(sMapScriptName)

    local rgpQuestProps = fetch_field_quests(rgiMapids, tpFieldQuests)
    return rgpQuestProps
end

local function fetch_accessible_quests_npc(sScriptName, tpFieldQuests)
    local fn_unit_key = fn_get_entry_key(true)
    local iNpcid = fn_unit_key(sScriptName)
    local rgiMapids = ctNpcs:get_locations(iNpcid)

    local rgpQuestProps = fetch_field_quests(rgiMapids, tpFieldQuests)
    return rgpQuestProps
end

local function fetch_accessible_quests_portal(sScriptName, tpFieldQuests)
    local fn_unit_key = fn_get_entry_key(false)
    local sPortalScriptName = fn_unit_key(sScriptName)
    local rgiMapids = ctExPortals:get_locations(sPortalScriptName)

    local rgpQuestProps = fetch_field_quests(rgiMapids, tpFieldQuests)
    return rgpQuestProps
end

local function fetch_accessible_quests_quest(sScriptName, tpFieldQuests)
    local fn_unit_key = fn_get_entry_key(true)
    local iQuestid = fn_unit_key(sScriptName)

    local rgpQuestProps = {}

    local pQuest = ctQuests:get_quest_by_id(iQuestid)
    if pQuest ~= nil then
        local pQuestProp = pQuest:get_start()
        local rgiMapids = fn_get_quest_fields(pQuestProp)

        rgpQuestProps = fetch_field_quests(rgiMapids, tpFieldQuests)
    end

    return rgpQuestProps
end

local function fetch_accessible_quests_reactor(sScriptName, tpFieldQuests)
    local fn_unit_key = fn_get_entry_key(true)
    local iReactorid = fn_unit_key(sScriptName)
    local rgiMapids = ctReactors:get_locations(iReactorid)

    local rgpQuestProps = fetch_field_quests(rgiMapids, tpFieldQuests)
    return rgpQuestProps
end

function fetch_table_directory_quest_method()
    local tfn_dir_quests = {}

    tfn_dir_quests["map"] = fetch_accessible_quests_map
    tfn_dir_quests["npc"] = fetch_accessible_quests_npc
    tfn_dir_quests["portal"] = fetch_accessible_quests_portal
    tfn_dir_quests["quest"] = fetch_accessible_quests_quest
    tfn_dir_quests["reactor"] = fetch_accessible_quests_reactor

    return tfn_dir_quests
end
