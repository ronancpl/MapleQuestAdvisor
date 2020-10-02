--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("router.structs.properties")
require("utils.array")
require("utils.class")

CQuestFrontierNode = createClass({
    bList = false,
    pItems = SArray:new(),
    fn_attain = nil,
    fn_diff = nil,
    fn_compare = nil,
    fn_create = nil
})

function CQuestFrontierNode:get_fn_attain()
    return self.fn_attain
end

function CQuestFrontierNode:get_fn_diff()
    return self.fn_diff
end

function CQuestFrontierNode:get_fn_compare()
    return self.fn_compare
end

function CQuestFrontierNode:get_fn_create()
    return self.fn_create
end

function CQuestFrontierNode:size()
    return self.pItems:size()
end

function CQuestFrontierNode:add(pQuestProp, fn_compare, fn_create, fn_get_property)
    local pFrontierProp = fn_create(pQuestProp, fn_get_property)

    local m_pItems = self.pItems
    local iInsIdx = m_pItems:bsearch(fn_compare, pFrontierProp, true, true)

    m_pItems:insert(pFrontierProp, iInsIdx)
end

function CQuestFrontierNode:fetch()
    local m_pItems = self.pItems

    local pQuestProp = m_pItems:remove_last()
    return pQuestProp
end

function CQuestFrontierNode:_is_prop_offbounds(pFrontierProp, pPlayerState, bSelect)
    return self:get_fn_attain(pFrontierProp, pPlayerState) ~= bSelect

end

function CQuestFrontierNode:update_take(pPlayerState, bSelect, fn_get_property)

end

function CQuestFrontierNode:update_put(tpQuestProps)

end
