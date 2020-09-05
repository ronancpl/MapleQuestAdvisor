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

local function load_units_data(sFilePath, CDataTable, fn_add_entry, fn_add_location, sUnitNodeStartsWith, sUnitNodeEndsWith, pFieldMeta)
    local pUnitData = CDataTable:new()
    local tUnitLocations = read_plain_table(sFilePath)

    local stIdx = #sUnitNodeStartsWith + 1
    local enIdx = -1 * (#sUnitNodeEndsWith + 1)

    for _, pUnitEntry in ipairs(tUnitLocations) do
        local iSrcid = tonumber(string.sub(pUnitEntry[1], stIdx, enIdx))
        fn_add_entry(pUnitData, iSrcid)

        for i = 2, #pUnitEntry, 1 do
            local iMapId = pFieldMeta:get_field_overworld(tonumber(pUnitEntry[i]))
            if (iMapId ~= nil) then
                fn_add_location(pUnitData, iSrcid, iMapId)
            end
        end
    end

    return pUnitData
end

local function load_npcs_data(sFilePath, pFieldMeta)
    local sUnitNodeStartsWith = "wz/Npc.wz/"
    local pUnitData = load_units_data(sFilePath, CNpcDataTable, CNpcDataTable.add_entry, CNpcDataTable.add_location, sUnitNodeStartsWith, ".img.xml", pFieldMeta)
    return pUnitData
end

local function load_mobs_data(sFilePath, pFieldMeta)
    local sUnitNodeStartsWith = "wz/Mob.wz/"

    local pUnitData = load_units_data(sFilePath, CMobDataTable, CMobDataTable.add_entry, CMobDataTable.add_location, sUnitNodeStartsWith, ".img.xml", pFieldMeta)
    return pUnitData
end

local function load_reactors_data(sFilePath, pFieldMeta)
    local sUnitNodeStartsWith = "wz/Reactor.wz/"

    local pUnitData = load_units_data(sFilePath, CReactorDataTable, CReactorDataTable.add_entry, CReactorDataTable.add_location, sUnitNodeStartsWith, ".img.xml", pFieldMeta)
    return pUnitData
end

function load_resources_units(pFieldMeta)
    local sDirPath = RPath.RSC_META_UNITS

    local pNpcData = load_npcs_data(sDirPath .. "/npc.txt", pFieldMeta)
    local pMobData = load_mobs_data(sDirPath .. "/mob.txt", pFieldMeta)
    local pReactorData = load_reactors_data(sDirPath .. "/reactor.txt", pFieldMeta)


end
