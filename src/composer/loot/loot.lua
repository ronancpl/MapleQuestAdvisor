--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("composer.containers.loots.loot")
require("utils.provider.text.csv")

local function load_loot_entries(ctLoots, fnLootEntry, sEntryKey, tLootRs)
    local tLootEntries = {}

    for _, tRow in ipairs(tLootRs) do
        local iSrcid = tonumber(tRow[sEntryKey])
        tLootEntries[iSrcid] = 1
    end

    for _, iSrcid in ipairs(tLootEntries) do
        fnLootEntry(ctLoots, iSrcid)
    end
end

local function load_loot_body(ctLoots, fnLootAdd, tLootRs, tLoadKeys)
    for _, tRow in ipairs(tLootRs) do
        local iSrcid = tonumber(tRow[tLoadKeys[1]])
        local iItemid = tonumber(tRow[tLoadKeys[2]])
        local siMinItems = type(tLoadKeys[3]) == "number" and tLoadKeys[3] or tonumber(tRow[tLoadKeys[3]])
        local siMaxItems = type(tLoadKeys[4]) == "number" and tLoadKeys[4] or tonumber(tRow[tLoadKeys[4]])
        local iChance = tonumber(tRow[tLoadKeys[5]])

        fnLootAdd(ctLoots, iSrcid, iItemid, iChance, siMinItems, siMaxItems)
    end
end

local function load_loot_by_type(ctLoots, fnLootEntry, fnLootAdd, sEntryKey, rgsRsKeys, sFilePath)
    local tLootRs = read_result_set(sFilePath, rgsRsKeys)
    if #tLootRs > 1 then
        load_loot_entries(ctLoots, fnLootEntry, sEntryKey, tLootRs)

        local tLoadKeys = rgsRsKeys
        load_loot_body(ctLoots, fnLootAdd, tLootRs, tLoadKeys)
    end
end

local function init_loot_table(sDirPath)
    local ctLoots = CLootTable:new()

    load_loot_by_type(ctLoots, CLootTable.add_mob_entry, CLootTable.add_mob_loot, "dropperid", {"dropperid", "itemid", "minimum_quantity", "maximum_quantity", "chance"}, sDirPath .. "/drop_data.csv")
    load_loot_by_type(ctLoots, CLootTable.add_reactor_entry, CLootTable.add_reactor_loot, "reactorid", {"reactorid", "itemid", 1, 1, "chance"}, sDirPath .. "/reactordrops.csv")

    ctLoots:squash_loots()

    return ctLoots
end

function load_resources_loots()
    local sDirPath = RPath.RSC_META_LOOTS

    local ctLoots = init_loot_table(sDirPath)
    return ctLoots
end
