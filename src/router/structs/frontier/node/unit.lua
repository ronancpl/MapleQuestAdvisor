--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("router.procedures.constant")
require("router.structs.frontier.node.node")
require("utils.struct.array")
require("utils.struct.class")

local function fn_default_player_property(pPlayerState)
    return 0
end

local function fn_compare_prop_unit(pFrontierProp, pFrontierOther)
    return (pFrontierOther:get_entry_set()[1] or U_INT_MIN) - (pFrontierProp:get_entry_set()[1] or U_INT_MIN)
end

local function fn_diff_prop_unit(pAcc, pFrontierProp, pPlayerState)
    local fn_get_player_property = pAcc:get_fn_player_property()
    local pQuestChkProp = pFrontierProp:get_requirement()

    local iProgress = fn_get_player_property(pPlayerState)
    local fn_pending_progress = pAcc:get_fn_pending_progress()
    local pRet = fn_pending_progress(pAcc, pQuestChkProp, iProgress)

    return pRet
end

local function fn_attain_prop_unit(pAcc, pFrontierProp, pPlayerState)
    local pRet = fn_diff_prop_unit(pAcc, pFrontierProp, pPlayerState)
    return pRet > 0
end

local function fn_make_prop_unit(pAcc, pQuestProp, pQuestChkProp)
    local pFrontierProp = CFrontierNodeProperties:new({pQuestProp = pQuestProp, pQuestChkProp = pQuestChkProp})

    local fn_get_property = pAcc:get_fn_property()
    local iValue = fn_get_property(pQuestChkProp)
    pFrontierProp:add(iValue, 1)

    return pFrontierProp
end

CQuestFrontierUnit = createClass({CQuestFrontierNode, {bList = false, fn_attain = fn_attain_prop_unit, fn_diff = fn_diff_prop_unit, fn_player_property = fn_default_player_property, fn_compare = fn_compare_prop_unit, fn_create = fn_make_prop_unit}})
