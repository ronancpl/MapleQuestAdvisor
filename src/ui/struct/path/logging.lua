--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("utils.logger.file")

local function trace_print_path(sTrackId, iDepth, pPath)
    log(LPath.TRAJECTORY, "path-" .. sTrackId .. "-" .. iDepth .. ".txt", pPath:to_string())
end

local function trace_print_lane(sTrackId, iDepth, pQuestProp, pLane)
    log(LPath.TRAJECTORY, "path-" .. sTrackId .. "-" .. iDepth .. ".txt", "==== QUEST " .. (pQuestProp and pQuestProp:get_name() or "-") .. " ====")
    for _, pPath in ipairs(pLane:get_recommended_paths()) do
        local sPath = pPath:to_string()
        trace_print_path(sTrackId, iDepth, pPath)
    end
    log(LPath.TRAJECTORY, "path-" .. sTrackId .. "-" .. iDepth .. ".txt", "====================")

    for pQuestProp, pSublane in pairs(pLane:get_sublanes()) do
        trace_print_lane(sTrackId, iDepth + 1, pQuestProp, pSublane)
    end
end

function trace_print_track(pTrack)
    local sTrackId = os.date("%H-%M-%S")

    log(LPath.TRAJECTORY, "track-" .. sTrackId .. ".txt", pTrack:to_string())
    for pQuestProp, pSublane in pairs(pTrack:get_sublanes()) do
        trace_print_lane(sTrackId, 0, pQuestProp, pSublane)
    end
end
