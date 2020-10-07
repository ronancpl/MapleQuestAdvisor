--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("router.structs.frontier.range")
require("utils.class")

CQuestFrontier = createClass({
    pHold = CQuestFrontierRange:new(),
    pSelect = CQuestFrontierRange:new()
})

function CQuestFrontier:init(ctAccessors)
    local rgsPropInvtNames
    local rgsPropUnitNames

    tsPropInvts, tsPropUnits = ctAccessors:get_accessor_range_keys()

    self.pHold:init(tsPropUnits, tsPropInvts)
    self.pSelect:init(tsPropUnits, tsPropInvts)
end

function CQuestFrontier:_is_quest_attainable(pQuestProp, pPlayerState)
    local iQuestid = pQuestProp:get_quest_id()
    local bStart = pQuestProp:is_start()

    return ctAccessors:is_player_have_prerequisites(true, pPlayerState, pQuestProp)
end

function CQuestFrontier:add(pQuestProp, pPlayerState, ctAccessors)
    local bSelect = self:_is_quest_attainable(pQuestProp, pPlayerState)
    local m_pRange = bSelect and self.pSelect or self.pHold

    m_pRange:add(pQuestProp, ctAccessors)
end

function CQuestFrontier:_update_range(pPlayerState, m_pRangeFrom, m_pRangeTo, bFromIsSelect)
    local tpTakeQuestProps = m_pRangeFrom:update_take(pPlayerState, bSelect)
    m_pRangeTo:update_put(tpTakeQuestProps)
end

function CQuestFrontier:update(pPlayerState)
    local m_pRangeHold = self.pHold
    local m_pRangeSelect = self.pSelect

    self:_update_range(pPlayerState, m_pRangeSelect, m_pRangeHold, true)
    self:_update_range(pPlayerState, m_pRangeHold, m_pRangeSelect, false)
end

function CQuestFrontier:fetch()
    local m_pRange = self.pSelect
    local pQuestProp = m_pRange:fetch()

    return pQuestProp
end
