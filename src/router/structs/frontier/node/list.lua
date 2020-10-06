--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("router.structs.frontier.node.node")
require("structs.storage.inventory")
require("utils.array")
require("utils.class")

local function fn_default_player_property(pPlayerState)
    return CInventory:new()
end

local function fn_compare_prop_invt(pFrontierProp, pFrontierOther)
    return pFrontierOther:size() - pFrontierProp:size()
end

local function fn_diff_prop_invt(pAcc, pFrontierProp, pPlayerState)
    local fn_get_player_property = pAcc:get_fn_player_property()

    local pProgress = fn_get_player_property(pPlayerState)
    local pRet = pAcc:get_fn_diff(rgReqItems, pProgress)

    return pRet
end

local function fn_attain_prop_invt(pAcc, pFrontierProp, pPlayerState)
    local pRet = fn_diff_prop_invt(pAcc, pFrontierProp, pPlayerState)
    return #pRet > 0
end

local function fn_make_prop_invt(pQuestProp, fn_get_property)
    local pFrontierProp = CFrontierNodeProperties:new()

    local ivtValue = fn_get_property(pQuestProp)
    for iId, iCount in pairs(ivtValue:get_items()) do
        pFrontierProp:add(iId, iCount)
    end

    return pFrontierProp
end

CQuestFrontierList = createClass({CQuestFrontierNode, {bList = true, fn_attain = fn_attain_prop_invt, fn_diff = fn_diff_prop_invt, fn_player_property = fn_default_player_property, fn_compare = fn_compare_prop_invt, fn_create = fn_make_prop_invt}})
