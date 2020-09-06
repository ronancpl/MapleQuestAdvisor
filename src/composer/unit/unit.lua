--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("composer.containers.units.mob_table")
require("composer.containers.units.npc_table")
require("composer.containers.units.reactor_table")
require("composer.containers.units.unit_table")
require("router.filters.path")
require("utils.provider.text.table")

local function load_units_table(sFilePath, CBaseUnitTable, fn_add_entry, fn_add_location, sUnitNodeStartsWith, sUnitNodeEndsWith, ctFieldsMeta)
    local ctUnits = CBaseUnitTable:new()
    local tUnitLocations = read_plain_table(sFilePath)

    local stIdx = #sUnitNodeStartsWith + 1
    local enIdx = -1 * (#sUnitNodeEndsWith + 1)

    for _, pUnitEntry in ipairs(tUnitLocations) do
        local iSrcid = tonumber(string.sub(pUnitEntry[1], stIdx, enIdx))
        fn_add_entry(ctUnits, iSrcid)

        for i = 2, #pUnitEntry, 1 do
            local iMapId = ctFieldsMeta:get_field_overworld(tonumber(pUnitEntry[i]))
            if (iMapId ~= nil) then
                fn_add_location(ctUnits, iSrcid, iMapId)
            end
        end
    end

    return ctUnits
end

local function load_npcs_table(sFilePath, ctFieldsMeta)
    local sUnitNodeStartsWith = "wz/Npc.wz/"
    local ctUnits = load_units_table(sFilePath, CNpcTable, CNpcTable.add_entry, CNpcTable.add_location, sUnitNodeStartsWith, ".img.xml", ctFieldsMeta)
    return ctUnits
end

local function load_mobs_table(sFilePath, ctFieldsMeta)
    local sUnitNodeStartsWith = "wz/Mob.wz/"

    local ctUnits = load_units_table(sFilePath, CMobTable, CMobTable.add_entry, CMobTable.add_location, sUnitNodeStartsWith, ".img.xml", ctFieldsMeta)
    return ctUnits
end

local function load_reactors_table(sFilePath, ctFieldsMeta)
    local sUnitNodeStartsWith = "wz/Reactor.wz/"

    local ctUnits = load_units_table(sFilePath, CReactorTable, CReactorTable.add_entry, CReactorTable.add_location, sUnitNodeStartsWith, ".img.xml", ctFieldsMeta)
    return ctUnits
end

function load_resources_units(ctFieldsMeta)
    local sDirPath = RPath.RSC_META_UNITS

    local ctNpcs = load_npcs_table(sDirPath .. "/npc.txt", ctFieldsMeta)
    local ctMobs = load_mobs_table(sDirPath .. "/mob.txt", ctFieldsMeta)
    local ctReactors = load_reactors_table(sDirPath .. "/reactor.txt", ctFieldsMeta)

    return ctNpcs, ctMobs, ctReactors
end
