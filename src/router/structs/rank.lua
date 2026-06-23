--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("composer.containers.quests.quest_grid")
require("router.constants.graph")
require("router.constants.quest")
require("router.procedures.constant")
require("router.structs.path")
require("utils.procedure.unpack")
require("utils.struct.class")
require("utils.struct.ranked_set")

CRankedPath = createClass({
    tpSetRankedPaths = {}
})

function CRankedPath:fetch_bucket_path(pCurrentPath)
    local iFromIdx = 1
    local iToIdx = math.min(pCurrentPath:size(), 2)

    local pBucketPath = pCurrentPath:subpath(iFromIdx, pCurrentPath:size() > 0 and iToIdx or -1)
    return pBucketPath:to_string()
end

function CRankedPath:init_bucket_path(pCurrentPath)
    local pSetRankedPaths = SRankedSet:new()
    pSetRankedPaths:set_capacity(RGraph.LEADING_PATH_CAPACITY)

    local pQuestPath = CQuestPath:new()
    pSetRankedPaths:insert(pQuestPath, 0.0)

    local m_tpSetRankedPaths = self.tpSetRankedPaths
    m_tpSetRankedPaths[self:fetch_bucket_path(pCurrentPath)] = pSetRankedPaths

    return pSetRankedPaths
end

function CRankedPath:assert_bucket_path(pCurrentPath)
    local m_tpSetRankedPaths = self.tpSetRankedPaths
    local pSetRankedPaths = m_tpSetRankedPaths[self:fetch_bucket_path(pCurrentPath)]
    if pSetRankedPaths == nil then
        pSetRankedPaths = self:init_bucket_path(pCurrentPath)
    end

    return pSetRankedPaths
end

local function route_path_copy(pQuestPath)
    local pPathNew = CQuestPath:new()

    local rgpQuestProps = pQuestPath:list()
    local nQuestProp = #rgpQuestProps
    for i = 1, nQuestProp, 1 do
        local pQuestProp = rgpQuestProps[i]
        local fVal = pQuestPath:get_node_value(i)
        local pQuestRoll = pQuestPath:get_node_allot(i)

        pPathNew:add(pQuestProp, pQuestRoll, fVal)
    end

    return pPathNew
end

local function route_quest_update_leading_subpath(pCurrentPath, pRankedPath)
    local pLeadingPath = pRankedPath:assert_bucket_path(pCurrentPath)

    local pTopPath = pLeadingPath:get_top()
    if pTopPath:is_subpath(pCurrentPath) then
        pLeadingPath:remove(pTopPath)
    end

    local pPath = route_path_copy(pCurrentPath)
    pLeadingPath:insert(pPath, pCurrentPath:value())
end

function CRankedPath:get_path_base_value(pCurrentPath)
    local m_tpSetRankedPaths = self.tpSetRankedPaths
    local pSetBucketPath = m_tpSetRankedPaths[self:fetch_bucket_path(pCurrentPath)]

    if pSetBucketPath ~= nil then
        return pSetBucketPath:get_base_value()
    else
        return 0.0
    end
end

function CRankedPath:get_top_path()
    local m_tpSetRankedPaths = self.tpSetRankedPaths

    local iVal = U_INT_MIN
    local pPath = CQuestPath:new()

    for _, pSetBucketPaths in pairs(m_tpSetRankedPaths) do
        local pCurrentPath = pSetBucketPaths:get_base()

        if pCurrentPath:value() > iVal then
            pPath = pCurrentPath
            iVal = pCurrentPath:value()
        end
    end

    return pPath
end

function CRankedPath:eval_interim_path(pCurrentPath)
    local pRankedPath = self
    if pCurrentPath:value() > pRankedPath:get_path_base_value(pCurrentPath) then
        route_quest_update_leading_subpath(pCurrentPath, pRankedPath)
    end
end

function CRankedPath:eval_leading_path(pLeadingPath)
    local pRankedPath = self
    local pTopPath = pLeadingPath:get_top_path()
    if pTopPath:value() > pRankedPath:get_path_base_value(pTopPath) then
        route_quest_update_leading_subpath(pTopPath, pRankedPath)
    end
end

local function rank_path_grade2(c, g)
    if c <= g then
        return g
    else
        return rank_path_grade2(c - g, g + 1)
    end
end

local function rank_path_grade(c)
    if c <= 0 then return 0 end
    return rank_path_grade2(c, 1)
end

local function rank_path_value(pCurrentPath, pSlctQuestProp)
    local iVal = pCurrentPath:value()
    if not pCurrentPath:is_empty() and pSlctQuestProp ~= nil then
        local pBaseQuest = ctQuests:get_quest_by_id(pSlctQuestProp:get_quest_id())
        local pBaseQuestProp = pBaseQuest:get_start()
        local bBaseQuestline = true

        local tFinalQuests = STable:new()
        tFinalQuests:insert(pBaseQuest, 1)
        fetch_quests_by_questline(tFinalQuests)

        for pQuest, _ in pairs(tFinalQuests:get_entry_set()) do
            local iNext = #ctQuests:get_next_quest_prop(pCurQuestProp)
            if iNext > 0 then
                tFinalQuests:remove(pQuest)
            end
        end

        for _, pQuestProp in ipairs(pCurrentPath:list()) do
            local pQuest = ctQuests:get_quest_by_id(pQuestProp:get_quest_id())
            local pFirstQuestProp = ctQuests:get_questline(pQuest):get_start()

            if not tFinalQuests:contains(pQuest) and pBaseQuestProp ~= pFirstQuestProp then
                bBaseQuestline = false
                break
            end
        end

        if bBaseQuestline then
            iVal = iVal + (rank_path_grade(#keys(tQuests)) * RQuest.QUESTS.QuestlineBoost)
        end
    end

    return iVal
end

function CRankedPath:export_paths()
    local nPaths = RGraph.LEADING_PATH_CAPACITY

    local pLeadingPath = SRankedSet:new()
    pLeadingPath:set_capacity(RGraph.LEADING_PATH_CAPACITY)

    local pSlctQuestProp = nil
    if pUiWmap ~= nil then
        local pTrack = pUiWmap:get_properties():get_track()
        if pTrack ~= nil then
            pSlctQuestProp = pTrack:get_top_quest()
        end
    end

    for _, pSetBucketPaths in pairs(self.tpSetRankedPaths) do
        local pCurrentPath = pSetBucketPaths:get_base() -- insert top of each path bucket

        local pPath = route_path_copy(pCurrentPath)
        pLeadingPath:insert(pPath, rank_path_value(pCurrentPath, pSlctQuestProp))
    end

    return pLeadingPath
end

function CRankedPath:insert(pCurrentPath)
    route_quest_update_leading_subpath(pCurrentPath, self)
end

function CRankedPath:list()
    local rgpList = SArray:new()
    for _, pSetBucketPaths in pairs(self.tpSetRankedPaths) do
        rgpList:add(pSetBucketPaths)
    end

    return rgpList
end

function CRankedPath:get_entry_set()
    local tpItems = {}
    for _, pSetBucketPaths in pairs(self.tpSetRankedPaths) do
        for pQuestPath, fVal in pairs(pSetBucketPaths:get_entry_set()) do
            tpItems[pQuestPath] = fVal
        end
    end

    return tpItems
end

function CRankedPath:debug_paths()
    log(LPath.PROCEDURES, "path_sequences.txt", " ---- QUEST STRING ----")

    for _, pSetBucketPaths in pairs(self.tpSetRankedPaths) do
        local st = ""
        for pQuestPath, fVal in pairs(pSetBucketPaths:get_entry_set()) do
            st = st .. pQuestPath:to_string() .. " (" .. tostring(fVal) .. "),"
            log(LPath.PROCEDURES, "path_sequences.txt", st)
        end

        log(LPath.PROCEDURES, "path_sequences.txt", "")
    end

    log(LPath.PROCEDURES, "path_sequences.txt", " ----------------------")
end
