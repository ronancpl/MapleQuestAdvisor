--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

local function fn_property_diff_pending(iRequired, iSeized)
    return iRequired - iSeized
end

function fn_diff_exceeded(pQuestAcc, pQuestProps, iSeized)
    local fn_req_prop = pQuestAcc:get_fn_property()
    local iRequired = fn_req_prop(pQuestProps)

    local iPending = fn_property_diff_pending(iSeized, iRequired)
    return -iPending
end

function fn_diff_pending(pQuestAcc, pQuestProps, iSeized)
    local fn_req_prop = pQuestAcc:get_fn_property()
    local iRequired = fn_req_prop(pQuestProps)

    local iPending = fn_property_diff_pending(iRequired, iSeized)
    return iPending
end

local function fn_property_diff_pending_list(tiReqItems, ivtSeized)
    local tPending = {}
    for iId, iCount in pairs(tiReqItems) do
        local iLeft = iCount - ivtSeized:get_item(iId)
        if iLeft > 0 then
            tPending[iId] = iLeft
        end
    end

    return tPending
end

function fn_diff_pending_list(pQuestAcc, pQuestProps, ivtSeized)
    local fn_req_prop = pQuestAcc:get_fn_property()

    local ivtReqItems = fn_req_prop(pQuestProps)
    local tiReqItems = ivtReqItems:get_items()

    local tPending = fn_property_diff_pending_list(tiReqItems, ivtSeized)
    return tPending
end

function fn_diff_zero(pQuestAcc, pQuestProps, iSeized)
    return 0
end

function fn_diff_avail(pQuestAcc, pQuestProps, iSeized)
    local fn_req_prop = pQuestAcc:get_fn_property()
    local bAvailable = fn_req_prop(pQuestProps)

    return bAvailable and 0 or 1
end
