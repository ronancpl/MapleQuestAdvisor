--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("router.structs.frontier.properties")
require("structs.quest.properties")
require("utils.struct.array")
require("utils.struct.class")

CQuestFrontierNode = createClass({
    bList = false,
    rgpItems = SArray:new(),
    tpSetItems = {},
    pQuestAcc = nil,
    fn_attain = nil,
    fn_diff = nil,
    fn_player_property = nil,
    fn_compare = nil,
    fn_sort = nil,
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

local function fn_compare_property(pFrontierProp, pQuestProp)
    return CQuestProperties.compare(pFrontierProp:get_property(), pQuestProp)
end

local function fn_sort_attainable(m_fn_attainable, m_fn_diff, m_pQuestAcc, pPlayerState)
    return function(a, b)
        return m_fn_attainable(m_fn_diff, m_pQuestAcc)(a, pPlayerState) < m_fn_attainable(m_fn_diff, m_pQuestAcc)(b, pPlayerState)
    end
end

function CQuestFrontierNode:get_fn_sort(pPlayerState)
    local m_pQuestAcc = self.pQuestAcc
    local m_fn_diff = self.fn_diff
    local m_fn_attainable = m_pQuestAcc:get_fn_attainable()

    local fn_sort = fn_sort_attainable(m_fn_attainable, m_fn_diff, m_pQuestAcc, pPlayerState)
    return fn_sort
end

function CQuestFrontierNode:_update_item_set(pQuestProp, iCount)
    local m_tpSetItems = self.tpSetItems

    local iPropCount = m_tpSetItems[pQuestProp]
    if iCount > 0 then
        m_tpSetItems[pQuestProp] = (m_tpSetItems[pQuestProp] or 0) + iCount
    else
        if iPropCount ~= nil then
            iPropCount = iPropCount + iCount
            if iPropCount > 0 then
                m_tpSetItems[pQuestProp] = iPropCount
            else
                m_tpSetItems[pQuestProp] = nil
            end
        end
    end
end

function CQuestFrontierNode:contains(pQuestProp)
    local m_tpSetItems = self.tpSetItems
    return m_tpSetItems[pQuestProp] ~= nil
end

function CQuestFrontierNode:size()
    return self.rgpItems:size()
end

function CQuestFrontierNode:add(pQuestProp, pQuestChkProp)
    local m_pQuestAcc = self.pQuestAcc
    local fn_create = self:get_fn_create()
    local fn_compare = self.fn_comparing

    local pFrontierProp = fn_create(m_pQuestAcc, pQuestProp, pQuestChkProp)

    local m_rgpItems = self.rgpItems
    local iInsIdx = m_rgpItems:bsearch(fn_compare, pFrontierProp, true, true)
    m_rgpItems:insert(pFrontierProp, iInsIdx)

    self:_update_item_set(pQuestProp, 1)
end

function CQuestFrontierNode:find(pQuestProp)
    local m_rgpItems = self.rgpItems
    local fn_select_quest_id = function (pFrontierProp) return fn_compare_property(pFrontierProp, pQuestProp) end
    local iIdx = m_rgpItems:index_of(fn_select_quest_id, false)
    return iIdx
end

function CQuestFrontierNode:count()
    local m_rgpItems = self.rgpItems
    return m_rgpItems:size()
end

function CQuestFrontierNode:list()
    local m_rgpItems = self.rgpItems
    return m_rgpItems:list()
end

function CQuestFrontierNode:remove(pQuestProp)
    local iRmvIdx = self:find(pQuestProp)
    if iRmvIdx > 0 then
        local m_rgpItems = self.rgpItems
        m_rgpItems:remove(iRmvIdx, iRmvIdx)

        self:_update_item_set(pQuestProp, -1)
    end
end

local function fetch_update_iterator_step(rgpItems, bSelect, iIdx)
    local iStart
    local iEnd

    if bSelect then
        iStart = 1
        iEnd = iIdx - 1
    else
        iStart = iIdx > 0 and iIdx or rgpItems:size() + 1
        iEnd = rgpItems:size()
    end

    return iStart, iEnd
end

function CQuestFrontierNode:update_take(pPlayerState, bSelect)
    local m_pQuestAcc = self.pQuestAcc
    local m_fn_diff = self.fn_diff
    local m_fn_attainable = m_pQuestAcc:get_fn_attainable()


    local m_rgpItems = self.rgpItems
    local iIdx = m_rgpItems:bsearch(m_fn_attainable(m_fn_diff, m_pQuestAcc), pPlayerState, true, true)

    local iStart
    local iEnd
    iStart, iEnd = fetch_update_iterator_step(m_rgpItems, bSelect, iIdx)

    local rgpFrontierProps = m_rgpItems:remove(iStart, iEnd)
    for _, pFrontierProp in ipairs(rgpFrontierProps) do
        local pQuestProp = pFrontierProp:get_property()
        self:_update_item_set(pQuestProp, -1)
    end

    return rgpFrontierProps:list()
end

function CQuestFrontierNode:_fetch_frontier_update_order(rgpFrontierProps, rgpCurItems)
    local bRes = false
    if #rgpFrontierProps > 0 and #rgpCurItems > 0 then
        local fn_compare = self.fn_comparing
        if fn_compare(rgpFrontierProps[1], rgpCurItems[1]) < 0 then
            bRes = true
        end
    end

    if bRes then
        return rgpFrontierProps, rgpCurItems
    else
        return rgpCurItems, rgpFrontierProps
    end
end

function CQuestFrontierNode:update_put(pPlayerState, rgpFrontierProps, bSelect)
    local m_rgpItems = self.rgpItems

    local rgpCurItems
    if bSelect then
        rgpCurItems = m_rgpItems:remove_all()
    else
        rgpCurItems = {}
    end

    local rgpItemsLeft
    local rgpItemsRight
    rgpItemsLeft, rgpItemsRight = self:_fetch_frontier_update_order(rgpFrontierProps, rgpCurItems)

    local fn_compare = self.fn_comparing

    m_rgpItems:add_all(rgpItemsLeft)
    m_rgpItems:add_all(rgpItemsRight)

    for _, pFrontierProp in ipairs(rgpFrontierProps) do
        local pQuestProp = pFrontierProp:get_property()
        self:_update_item_set(pQuestProp, 1)
    end
end

function CQuestFrontierNode:update_prepare(pPlayerState)
    local m_rgpItems = self.rgpItems
    local fn_sort = self:get_fn_sort(pPlayerState)  -- sort array to attend playerstate order

    local m_pQuestAcc = self.pQuestAcc
    local m_fn_diff = self.fn_diff
    local m_fn_attainable = m_pQuestAcc:get_fn_attainable()
    self.fn_comparing = m_fn_attainable(m_fn_diff, m_pQuestAcc)
    m_rgpItems:sort(fn_sort)
end

function CQuestFrontierNode:update_normalize()
    local m_rgpItems = self.rgpItems
    local fn_sort = function (a, b) return (self:get_fn_compare())(a, b) < 0 end           -- sort array to playerstate-less order

    self.fn_comparing = self:get_fn_compare()
    m_rgpItems:sort(fn_sort)
end
