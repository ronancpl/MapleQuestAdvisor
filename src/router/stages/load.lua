--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("composer.containers.strings.item")
require("composer.containers.strings.mob")
require("composer.containers.strings.npc")
require("composer.containers.strings.quest")
require("composer.field.field")
require("composer.field.station")
require("composer.field.worldmap")
require("composer.loot.acquisition")
require("composer.loot.loot")
require("composer.loot.maker")
require("composer.loot.refine")
require("composer.quest.quest")
require("composer.script.script")
require("composer.script.adjoin.field")
require("composer.script.adjoin.quest")
require("composer.unit.mob_group")
require("composer.unit.player")
require("composer.unit.unit")
require("router.constants.server")
require("router.structs.landscape.world")
require("utils.logger.file")
--require("utils.procedure.print")
require("utils.provider.xml.provider")

local function post_process_quests(ctQuests, ctNpcs, ctFieldsMeta)
    ctQuests:dispose_inoperative_quests()
    ctQuests:dispose_missing_prequests()
    ctQuests:apply_starting_level()
    ctQuests:build_questline_path()
    apply_quest_npc_field_areas(ctQuests, ctNpcs, ctFieldsMeta)
end

local function post_process_fields(ctFieldsDist, ctFieldsLink)
    local ctFieldsLandscape = CFieldLandscape:new()
    ctFieldsLandscape:scan_region_areas(ctFieldsDist)
    ctFieldsLandscape:make_remissive_index_area_region()
    ctFieldsLink:determine_regional_station_area_neighbors(ctFieldsLandscape, ctFieldsDist)
end

local function post_process_resources(ctQuests, ctNpcs, ctFieldsDist, ctFieldsMeta, ctFieldsLink)
    post_process_quests(ctQuests, ctNpcs, ctFieldsMeta)
    post_process_fields(ctFieldsDist, ctFieldsLink)
end

local function load_resources_internal()
    SXmlProvider:init()

    ctQuestsMeta = load_meta_resources_quests()
    --printable(ctQuestsMeta)

    ctQuests = load_resources_quests()
    --printable(ctQuests)

    ctFieldsWmap = load_resources_worldmap()
    --printable(ctFieldsWmap)

    ctFieldsMeta = load_meta_resources_fields()
    --printable(ctFieldsMeta)

    ctFieldsDist = load_resources_fields(ctFieldsMeta, ctFieldsWmap)
    --printable(ctFieldsDist)

    ctFieldsLink = load_resources_stations()
    --printable(ctFieldsLink)

    load_script_resources_fields(ctFieldsDist, ctFieldsMeta, ctFieldsWmap)
    clear_redundant_resources_fields(ctFieldsDist)

    ctNpcs, ctMobs, ctReactors, ctExEvents, ctExMaps, ctExPortals = load_resources_units(ctFieldsMeta)
    --printable(ctNpcs)
    --printable(ctMobs)
    --printable(ctReactors)
    --printable(ctExEvents)
    --printable(ctExMaps)
    --printable(ctExPortals)

    ctMobsGroup = load_resources_mob_quest_group_count()

    ctPlayersMeta = load_resources_player()
    --printable(ctPlayersMeta)

    ctLoots = load_resources_loots()
    --printable(ctLoots)

    ctMaker = load_resources_maker()
    --printable(ctMaker)

    ctRefine = load_resources_refine()
    --printable(ctRefine)

    ctItemsMeta = load_meta_resources_items()
    --printable(ctItemsMeta)

    ctMobsMeta = load_meta_resources_mobs()
    --printable(ctMobsMeta)

    ctNpcsMeta = load_meta_resources_npcs()
    --printable(ctNpcsMeta)

end

function load_resources()
    log(LPath.OVERALL, "log.txt", "Load quest resources...")

    load_resources_internal()
    post_process_resources(ctQuests, ctNpcs, ctFieldsDist, ctFieldsMeta, ctFieldsLink)
end

function load_script_resources()
    local tpDirScriptRscs = load_script_directory_resources()

    append_quest_script_resources(tpDirScriptRscs)
    append_field_script_resources(tpDirScriptRscs)
end

function load_loot_retrieval_resources()
    log(LPath.OVERALL, "log.txt", "Load loot retrieval resources...")

    ctRetrieveLootMobs, ctRetrieveLootReactors = load_acquisition_loot_table(RFlags.DROP_RATE, ctFieldsLandscape, ctFieldsMeta, ctLoots)
    --printable(ctRetrieveLootMobs)
    --printable(ctRetrieveLootReactors)
end
