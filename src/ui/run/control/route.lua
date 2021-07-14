--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("router.constants.path")
require("router.stages.reroute")
require("router.structs.lane")
require("structs.player")
require("ui.struct.path.pathing")
require("utils.procedure.string")
require("utils.provider.io.wordlist")
require("utils.struct.table")

function load_board_quests()
    local tQuests = STable:new()

    local fIn = io.open("../" .. RPath.SAV_QBOARD, "r")
    if fIn ~= nil then
        for sLine in fIn:lines() do
            local rgsQuests = split_csv(sLine)

            for _, sQuestid in ipairs(rgsQuests) do
                local pQuest = ctQuests:get_quest_by_id(tonumber(sQuestid))
                tQuests:insert(pQuest, 1)
            end
        end

        io.close(fIn)
    end

    return tQuests
end

function save_board_quests(tQuests)
    local fOut = io.open("../" .. RPath.SAV_QBOARD, "w")
    if fOut ~= nil then
        local st = ""
        for pQuest, _ in pairs(tQuests:get_entry_set()) do
            st = st .. tostring(pQuest:get_quest_id()) .. ","
        end
        fOut:write(st)

        io.close(fOut)
    end
end

local function load_route_quests(pPlayer)
    local rgsLines = {}

    local fIn = io.open("../" .. RPath.SAV_ROUTE, "r")
    if fIn ~= nil then
        for sLine in fIn:lines() do
            table.insert(rgsLines, sLine)
        end

        io.close(fIn)
    end

    local tRoute = csv_read_route_quest_path(rgsLines, pPlayer)
    return tRoute
end

local function load_track_lane(pPlayer)
    local tRoute = load_route_quests(pPlayer)
    local pRouteLane = generate_subpath_lane(tRoute)

    local pTrack = CTracePath:new()
    pTrack:load(pRouteLane)

    return pTrack, tRoute
end

function run_route_bt_load(pPlayer)  -- loads last quest laning action
    local pTrack, tRoute = load_track_lane(pPlayer)
    return pTrack, tRoute
end

local function write_track_quests(tRoute)
    local fOut = io.open("../" .. RPath.SAV_ROUTE, "w")
    if fOut ~= nil then
        local rgsPaths = csvify_route_quest_path(tRoute)
        for _, sRoute in ipairs(rgsPaths) do
            fOut:write(sRoute .. "\n")
        end

        io.close(fOut)
    end
end

function run_route_bt_save(tRoute)  -- saves last quest laning action
    write_track_quests(tRoute)
end

function load_lookahead_track(pPlayer)
    local pPlayerCopy = CPlayer:new()
    pPlayerCopy:copy(pPlayer)

    return load_track_lane(pPlayerCopy)
end
