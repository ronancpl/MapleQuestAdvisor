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

local function fn_compare_prop_invt(pFrontierProp, pFrontierOther)
    return pFrontierOther:size() - pFrontierProp:size()
end

local function fn_make_prop_invt(pQuestProp, fn_get_property)
    local pFrontierProp = CFrontierNodeProperties:new()

    local ivtValue = fn_get_property(pQuestProp)
    for iId, iCount in pairs(ivtValue:get_items()) do
        pFrontierProp:add(iId, iCount)
    end

    return pFrontierProp
end

CQuestFrontierList = createClass({CQuestFrontierNode, {bList = true, fn_compare = fn_compare_prop_invt, fn_create = fn_make_prop_invt}})
