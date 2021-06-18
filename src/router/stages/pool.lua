--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("composer.quest.quest")
require("router.constants.graph")
require("router.procedures.player.update")
require("utils.logger.file")
require("utils.provider.text.csv")
require("utils.struct.table")

local function route_csvify_quest_pool(tQuests)
    local sQuests = ",\"quest\"\n"
    for _, pPair in ipairs(spairs(tQuests:get_entry_set(), function (a, b) return a:get_quest_id() < b:get_quest_id() end)) do
        local pQuest = pPair[1]
        sQuests = sQuests .. "0," .. pQuest:get_quest_id() .. "\n"
    end

    return sQuests
end

local function fetch_quest_pool_list(pGridQuests)
    local rgpQuestProps = {}

    for _, pQuest in ipairs(pGridQuests:list()) do
        table.insert(rgpQuestProps, pQuest:get_start())
    end

    return rgpQuestProps
end

function pool_select_graph_quests(pGridQuests, pPlayer)
    log(LPath.OVERALL, "log.txt", "Select quests to board... (total " .. pGridQuests:length() .. " quests loaded)")

    local rgpPoolProps = fetch_quest_pool_list(pGridQuests)
    apply_initial_player_state(pPlayer, rgpPoolProps)  -- set up initial player-state requirements

    local tQuests = pGridQuests:fetch_top_quests_by_player(pPlayer, RGraph.POOL_MIN_QUESTS)
    log(LPath.QUEST_BOARD, "pool-" .. os.date("%H-%M-%S") .. ".txt", route_csvify_quest_pool(tQuests))
    return tQuests
end

local function pool_load_graph_quests_from_file(pGridQuests, sFilePath)
    local rgiQuests = {}

    local tPoolRs = read_result_set(sFilePath, {"quest"})
    if #tPoolRs > 1 then
        for _, tRow in ipairs(tPoolRs) do
            local iQuestid = tonumber(tRow["quest"])
            table.insert(rgiQuests, iQuestid)
        end
    end

    local tQuests = pGridQuests:fetch_quests_by_list(rgiQuests)
    return tQuests
end

function pool_load_graph_quests(pGridQuests, pPlayer, sDatePath, sTimePath)
    local sFilePath = LPath.LOG_DIR .. LPath.QUEST_BOARD .. sDatePath .. "/pool-" .. sTimePath .. ".txt"
    log(LPath.OVERALL, "log.txt", "Load quests to board... (file '" .. sFilePath .. ")'")

    local tQuests = pool_load_graph_quests_from_file(pGridQuests, sFilePath)
    return tQuests
end

function pool_read_graph_quests(pGridQuests, sFilePath)
    local tQuests = pool_load_graph_quests_from_file(pGridQuests, sFilePath)
    return tQuests
end

function pool_write_graph_quests(tQuests, sFilePath)
    local fOut = io.open(sFilePath, "w")
    if fOut ~= nil then
        local sRoute = route_csvify_quest_pool(tQuests)
        fOut:write(sRoute)
        io.close(fOut)
    end
end
