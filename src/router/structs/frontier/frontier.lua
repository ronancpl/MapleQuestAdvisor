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

function CQuestFrontier:init(ctAccessors) do
    local rgsPropInvtNames
    local rgsPropUnitNames

    rgsPropInvtNames, rgsPropUnitNames = ctAccessors:get_accessor_range_keys()

    self.pHold:init(rgsPropInvtNames, rgsPropUnitNames)
    self.pSelect:init(rgsPropInvtNames, rgsPropUnitNames)
end

function CQuestFrontier:_is_quest_attainable(pQuestProp, pPlayerState)
    local iQuestid = pQuestProp:get_quest_id()
    local bStart = pQuestProp:is_start()

    return ctAccessors:is_player_have_prerequisites(true, pPlayerState, pQuestProp)
end

function CQuestFrontier:add(pQuestProp, pPlayerState)
    local bSelect = self:_is_quest_attainable(pQuestProp, pPlayerState)
    local m_pRange = bSelect and self.pSelect or self.pHold

    m_pRange:add(pQuestProp)
end

function CQuestFrontier:update(pPlayerState)

end

function CQuestFrontier:fetch()
    local m_pRange = self.pSelect
    local pQuestProp = m_pRange:fetch()

    return pQuestProp
end
