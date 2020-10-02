--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

function fn_property_diff_pending(pQuestAcc, iRequired, iSeized)
    return iSeized - iRequired
end

function fn_diff_pending(pQuestAcc, pQuestProp, iSeized)
    local fn_quest_prop = pQuestAcc:get_fn_property()
    local iRequired = fn_quest_prop(pQuestProp)

    local iPending = fn_property_diff_pending(pQuestAcc, iRequired, iSeized)
    return iPending
end

function fn_property_diff_pending_list(pQuestAcc, rgReqItems, ivtSeized)
    local tPending = {}
    for iId, iCount in ipairs(rgReqItems) do
        local iLeft = iCount - ivtSeized:get_item(iId)
        if iLeft > 0 then
            tPending[iId] = iLeft
        end
    end

    return tPending
end

function fn_diff_pending_list(pQuestAcc, pQuestProp, ivtSeized)
    local fn_quest_prop = pQuestAcc:get_fn_property()
    local rgReqItems = fn_quest_prop(pQuestProp)

    local tPending = fn_property_diff_pending_list(pQuestAcc, rgReqItems, ivtSeized)
    return tPending
end

function fn_diff_zero(pQuestAcc, pQuestProp, iSeized)
    return 0
end
