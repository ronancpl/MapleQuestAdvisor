--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("router.structs.frontier.list")
require("router.structs.frontier.range")
require("utils.struct.class")

CQuestFrontier = createClass({
    pHold = CQuestFrontierRange:new(),
    pSelect = CQuestFrontierRange:new(),
    pQuestStack = CQuestFrontierQuestList:new()
})

function CQuestFrontier:init(ctAccessors)
    local rgpAccInvts
    local rgpAccUnits

    rgpAccInvts, rgpAccUnits = ctAccessors:get_accessor_range_keys()

    self.pHold:init(rgpAccUnits, rgpAccInvts)
    self.pSelect:init(rgpAccUnits, rgpAccInvts)
end

function CQuestFrontier:_is_quest_attainable(pQuestProp, pPlayerState, ctAccessors)
    return ctAccessors:is_player_have_prerequisites(true, pPlayerState, pQuestProp)
end

function CQuestFrontier:contains(pQuestProp)
    local m_pQuestStack = self.pQuestStack
    return m_pQuestStack:contains(pQuestProp)
end

function CQuestFrontier:is_quest_accessible(pQuestProp)
    local m_pRange = self.pSelect
    return m_pRange:contains(pQuestProp)
end

function CQuestFrontier:add(pQuestProp, pPlayerState, ctAccessors)
    local bSelect = self:_is_quest_attainable(pQuestProp, pPlayerState, ctAccessors)
    local m_pRange = bSelect and self.pSelect or self.pHold

    m_pRange:add(pQuestProp, ctAccessors)

    local m_pQuestStack = self.pQuestStack
    m_pQuestStack:add(pQuestProp)
end

function CQuestFrontier:_update_range(pPlayerState, m_pRangeFrom, m_pRangeTo, bFromIsSelect)
    local tpTakeQuestProps = m_pRangeFrom:update_take(pPlayerState, bFromIsSelect)
    m_pRangeTo:update_put(pPlayerState, tpTakeQuestProps, bFromIsSelect)
end

function CQuestFrontier:_prepare_range(m_pRangeFrom, pPlayerState)
    m_pRangeFrom:prepare_range(pPlayerState)
end

function CQuestFrontier:_normalize_range(m_pRangeFrom)
    m_pRangeFrom:normalize_range()
end

function CQuestFrontier:update(pPlayerState)
    local m_pRangeHold = self.pHold
    local m_pRangeSelect = self.pSelect

    self:_prepare_range(m_pRangeSelect, pPlayerState)
    self:_prepare_range(m_pRangeHold, pPlayerState)

    self:_update_range(pPlayerState, m_pRangeSelect, m_pRangeHold, true)
    self:_update_range(pPlayerState, m_pRangeHold, m_pRangeSelect, false)

    self:_normalize_range(m_pRangeSelect)
    self:_normalize_range(m_pRangeHold)
end

function CQuestFrontier:debug_front()
    self.pSelect:debug_front("slt")
    self.pHold:debug_front("hld")
end

function CQuestFrontier:peek()
    local m_pQuestStack = self.pQuestStack
    local m_pRange = self.pSelect

    local pQuestProp
    while true do
        pQuestProp = m_pQuestStack:peek()

        -- keeps exploring the frontier stack, in search for a selectable quest for the player
        if pQuestProp == nil or m_pRange:contains(pQuestProp) then
            break
        end
    end

    return pQuestProp
end

function CQuestFrontier:fetch(pQuestTree, iQuestCount)
    local m_pQuestStack = self.pQuestStack
    local rgpQuestProps = m_pQuestStack:fetch(pQuestTree, iQuestCount)

    local m_pRange = self.pSelect
    for _, pQuestProp in ipairs(rgpQuestProps) do
        m_pRange:fetch(pQuestProp)
    end

    return rgpQuestProps
end

function CQuestFrontier:count()
    local tSelectCount = self.pSelect:count()
    local tHoldCount = self.pHold:count()

    local tRet = {}
    for pAcc, iSlctCount in pairs(tSelectCount) do
        local iHoldCount = tHoldCount[pAcc]

        local iCount = iSlctCount + iHoldCount
        tRet[pAcc] = iCount
    end

    return tRet
end
