--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("router.constants.graph")
require("router.structs.path")
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

function CRankedPath:eval_interim_path(pCurrentPath)
    local pRankedPath = self
    if pCurrentPath:value() > pRankedPath:get_path_base_value(pCurrentPath) then
        route_quest_update_leading_subpath(pCurrentPath, pRankedPath)
    end
end

function CRankedPath:export_paths()
    local nPaths = RGraph.LEADING_PATH_CAPACITY

    local nBuckets = 0
    for _, _ in pairs(self.tpSetRankedPaths) do
        nBuckets = nBuckets + 1
    end

    local nBucketPaths = math.floor(nPaths / nBuckets)
    local iRest = nPaths % nBuckets

    local pLeadingPath = SRankedSet:new()
    pLeadingPath:set_capacity(RGraph.LEADING_PATH_CAPACITY)

    for i = 1, nBucketPaths, 1 do
        for _, pSetBucketPaths in pairs(self.tpSetRankedPaths) do
            local rgpQuestPath = pSetBucketPaths:list()
            if i <= #rgpQuestPath then
                local pCurrentPath = rgpQuestPath[i]

                local pPath = route_path_copy(pCurrentPath)
                pLeadingPath:insert(pPath, pCurrentPath:value())
            else
                iRest = iRest + 1
            end
        end
    end

    local iPrevRest

    local i = nBucketPaths + 1
    while true do
        iPrevRest = iRest

        for _, pSetBucketPaths in pairs(self.tpSetRankedPaths) do
            local rgpQuestPath = pSetBucketPaths:list()

            if i <= #rgpQuestPath then
                local pCurrentPath = rgpQuestPath[i]

                local pPath = route_path_copy(pCurrentPath)
                pLeadingPath:insert(pPath, pCurrentPath:value())

                iRest = iRest - 1
                if iRest < 1 then
                    break
                end
            end
        end

        if iRest == iPrevRest then
            break
        end

        i = i + 1
    end

    return pLeadingPath
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
