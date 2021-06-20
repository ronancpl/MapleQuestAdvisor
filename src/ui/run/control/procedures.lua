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
require("router.stages.route")
require("router.structs.lane")
require("utils.procedure.string")
require("utils.provider.io.wordlist")

local function load_route_quests()
    local rgsPaths = {}

    local fIn = io.open("../" .. RPath.SAV_ROUTE, "r")
    if fIn ~= nil then
        for sLine in fIn:lines() do
            table.insert(rgsPaths, sLine)
        end

        io.close(fIn)
    end

    return rgsPaths
end

local function load_track_lane(pPlayer)
    local rgsPaths = load_route_quests()
    local pLeadingPath = load_route_graph_quests(pPlayer, rgsPaths, ctAccessors, ctAwarders, ctFieldsDist, ctPlayersMeta)
    local pRouteLane = generate_subpath_lane(pLeadingPath)

    return pRouteLane
end

function run_bt_load(pPlayer)  -- loads last quest laning action
    return load_track_lane(pPlayer)
end

local function write_track_quests(pLeadingPath)
    local fOut = io.open("../" .. RPath.SAV_ROUTE, "w")
    if fOut ~= nil then
        local rgsPaths = csvify_route_quest_path(pLeadingPath)
        for _, sRoute in ipairs(rgsPaths) do
            fOut:write(sRoute .. "\n")
        end

        io.close(fOut)
    end
end

function run_bt_save(pLeadingPath)  -- saves last quest laning action
    write_track_quests(pLeadingPath)
end
