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
require("utils.array")
require("utils.class")

local function fn_compare_prop_unit(pFrontierProp, pFrontierOther)
    return pFrontierOther:get(1) - pFrontierProp:get(1)
end

local function fn_attain_prop_unit(pReqAcc, pFrontierProp, pPlayerState)
    local pRet = fn_diff_prop_unit(pReqAcc, pFrontierProp, pPlayerState)
    return pRet > 0
end

local function fn_diff_prop_unit(pReqAcc, pFrontierProp, pPlayerState)
    local iProgress = pReqAcc:get_fn_player_property(pPlayerState)
    local pRet = pReqAcc:get_fn_diff(pReqAcc, pQuestProp, iProgress)    -- TODO: not pQuestProp

    return pRet
end

local function fn_make_prop_unit(pQuestProp, fn_get_property)
    local pFrontierProp = CFrontierNodeProperties:new()

    local iValue = fn_get_property(pQuestProp)
    pFrontierProp:add(iValue, 1)

    return pFrontierProp
end

CQuestFrontierUnit = createClass({CQuestFrontierNode, {bList = false, fn_attain = fn_attain_prop_unit, fn_diff = fn_diff_prop_unit, fn_compare = fn_compare_prop_unit, fn_create = fn_make_prop_unit}})
