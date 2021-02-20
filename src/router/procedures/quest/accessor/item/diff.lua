--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("router.procedures.inventory.maker")

local function fn_property_diff_pending_item_list(tiReqItems, ivtSeized)
    local tPending = {}
    for iId, iCount in pairs(tiReqItems) do
        local iLeft = iCount - ivtSeized:get_item(iId)
        if iLeft > 0 then
            local iLeft = iLeft - maker_get_item(ivtSeized, iId)
            if iLeft > 0 then
                tPending[iId] = iLeft
            end
        end
    end

    return tPending
end

function fn_diff_pending_item_list(pQuestAcc, pQuestProps, ivtSeized)
    local fn_req_prop = pQuestAcc:get_fn_property()

    local ivtReqItems = fn_req_prop(pQuestProps)
    local tiReqItems = ivtReqItems:get_items()

    local tPending = fn_property_diff_pending_item_list(tiReqItems, ivtSeized)
    return tPending
end
