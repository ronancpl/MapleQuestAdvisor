--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("composer.quest.quest")
require("router.filters.graph")
require("utils.logger.file")
require("utils.provider.text.csv")
require("utils.struct.table")

local function route_csvify_quest_pool(tQuests)
    local sQuests = "quest,"
    for pPair, _ in ipairs(spairs(tQuests:get_entry_set(), function (a, b) return a:get_quest_id() < b:get_quest_id() end)) do
        local pQuest = pPair[1]
        sQuests = sQuests .. pQuest:get_quest_id() .. ",\n"
    end

    return sQuests
end

function pool_select_graph_quests(pGridQuests, pPlayer)
    log(LPath.OVERALL, "log.txt", "Select quests to board... (total " .. pGridQuests:length() .. " quests loaded)")

    local tQuests = pGridQuests:fetch_top_quests_by_player(pPlayer, RGraph.POOL_MIN_QUESTS)
    log(LPath.QUEST_BOARD, "pool-" .. os.date("%H-%M-%S") .. ".txt", route_csvify_quest_pool(tQuests))
    return tQuests
end

local function pool_load_graph_quests_from_file(pGridQuests, sFilePath)
    local rgiQuests = {}

    local tPoolRs = read_result_set(sFilePath, "quest")
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
    local sFilePath = LPath.QUEST_BOARD .. "/" .. sDatePath .. "/" .. sTimePath .. ".txt"
    log(LPath.OVERALL, "log.txt", "Load quests to board... (file '" .. sFilePath .. ")'")

    local tQuests = pool_load_graph_quests_from_file(pGridQuests, sFilePath)
    return tQuests
end
