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
    pQuestAcc = nil,
    fn_attain = nil,
    fn_diff = nil,
    fn_player_property = nil,
    fn_compare = nil,
    fn_create = nil
})

function CQuestFrontierNode:get_fn_attain()
    return self.fn_attain
end

function CQuestFrontierNode:get_fn_diff()
    return self.fn_diff
end

function CQuestFrontierNode:get_fn_player_property()
    return self.fn_player_property
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

function CQuestFrontierNode:add(pQuestProp, pQuestChkProp)
    local m_pQuestAcc = self.pQuestAcc
    local fn_create = self:get_fn_create()
    local fn_compare = self:get_fn_compare()

    local pFrontierProp = fn_create(m_pQuestAcc, pQuestProp, pQuestChkProp)

    local m_pItems = self.pItems
    local iInsIdx = m_pItems:bsearch(fn_compare, pFrontierProp, true, true)

    m_pItems:insert(pFrontierProp, iInsIdx)
end

function CQuestFrontierNode:fetch()
    local m_pItems = self.pItems
    local pFrontierProp = m_pItems:remove_last()

    return pFrontierProp
end

local function fetch_update_iterator_step(pItems, bSelect, iIdx)
    local iStart
    local iEnd

    if bSelect then
        iStart = pItems:size()
        iEnd = iIdx - 1
    else
        iStart = 1
        iEnd = iIdx
    end

    return iStart, iEnd
end

local function fn_compare_attainable(m_pQuestAcc, fn_diff)
    return function(pFrontierProp, pPlayerState)
        return fn_diff(m_pQuestAcc, pFrontierProp, pPlayerState)
    end
end

function CQuestFrontierNode:update_take(pPlayerState, bSelect)
    local m_pQuestAcc = self.pQuestAcc
    local fn_diff = self:get_fn_diff()

    local m_pItems = self.pItems
    local fn_compare = fn_compare_attainable(m_pQuestAcc, fn_diff)
    print("&", (fn_diff(m_pQuestAcc, self.pItems.apItems[1], pPlayerState)()))
    local iIdx = m_pItems:bsearch(fn_compare, pPlayerState, true, true)

    local iStart
    local iEnd
    iStart, iEnd = fetch_update_iterator_step(m_pItems, bSelect, iIdx)

    local rgpQuestProps = m_pItems:remove(iStart, iEnd)
    return rgpQuestProps
end

function CQuestFrontierNode:update_put(rgpQuestProps)
    local m_pItems = self.pItems
    m_pItems:add_all(rgpQuestProps)
end
