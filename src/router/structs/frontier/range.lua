--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("router.structs.frontier.node.list")
require("router.structs.frontier.node.unit")
require("utils.struct.array")
require("utils.struct.class")
require("utils.struct.table")

CQuestFrontierRange = createClass({
    tpPropTypeQuests = {},
    rgpQuestStack = {}
})

function CQuestFrontierRange:_init_accessor_type(pAcc, CQuestRangeType)
    local m_tpPropTypeQuests = self.tpPropTypeQuests

    local fn_get_player_property = pAcc:get_fn_player_property()
    m_tpPropTypeQuests[pAcc] = CQuestRangeType:new({pQuestAcc = pAcc, fn_player_property = fn_get_player_property})
end

function CQuestFrontierRange:init(rgpAccUnits, rgpAccInvts)
    for _, pAcc in ipairs(rgpAccUnits) do
        self:_init_accessor_type(pAcc, CQuestFrontierUnit)
    end

    for _, pAcc in ipairs(rgpAccInvts) do
        self:_init_accessor_type(pAcc, CQuestFrontierList)
    end
end

function CQuestFrontierRange:_add_to_node(pAcc, pQuestProp, pQuestChkProp, CQuestRangeType)
    local m_tpPropTypeQuests = self.tpPropTypeQuests

    local pTypeRange = m_tpPropTypeQuests[pAcc]
    pTypeRange:add(pQuestProp, pQuestChkProp)
end

function CQuestFrontierRange:add(pQuestProp, ctAccessors)
    local pQuestChkProp = pQuestProp:get_requirement()

    for _, pAcc in ipairs(ctAccessors:get_accessors_by_active_requirements(pQuestProp, true)) do
        if pAcc ~= nil then
            self:_add_to_node(pAcc, pQuestProp, pQuestChkProp, CQuestFrontierList)
        end
    end

    for _, pAcc in ipairs(ctAccessors:get_accessors_by_active_requirements(pQuestProp, false)) do
        if pAcc ~= nil then
            self:_add_to_node(pAcc, pQuestProp, pQuestChkProp, CQuestFrontierUnit)
        end
    end

    table.insert(self.rgpQuestStack, pQuestProp)
end

function CQuestFrontierRange:update_take(pPlayerState, bSelect)
    local m_tpPropTypeQuests = self.tpPropTypeQuests
    local tpTakeQuestProps = STable:new()

    for pAcc, tpQuestProps in pairs(m_tpPropTypeQuests) do
        local rgpQuestProps = tpQuestProps:update_take(pPlayerState, bSelect)
        tpTakeQuestProps:insert(pAcc, rgpQuestProps)
    end

    return tpTakeQuestProps
end

function CQuestFrontierRange:update_put(tpTakeQuestProps)
    local m_tpPropTypeQuests = self.tpPropTypeQuests

    for pAcc, rgpQuestProps in pairs(tpTakeQuestProps:get_entry_set()) do
        local tpQuestProps = m_tpPropTypeQuests[pAcc]
        tpQuestProps:update_put(rgpQuestProps)
    end
end

function CQuestFrontierRange:_remove_from_nodes(pQuestProp)
    local m_tpPropTypeQuests = self.tpPropTypeQuests
    for _, pTypeRange in pairs(m_tpPropTypeQuests) do
        pTypeRange:remove(pQuestProp)
    end
end

function CQuestFrontierRange:_should_fetch_quest(pCurQuestProp, rgpAccs)
    if #rgpAccs > 0 then
        local m_tpPropTypeQuests = self.tpPropTypeQuests

        for _, pAcc in pairs(rgpAccs) do
            local pNode = m_tpPropTypeQuests[pAcc]
            if not pNode:contains(pCurQuestProp) then     -- meaning this requisite has not been met by player
                return false
            end
        end
    end

    return true
end

function CQuestFrontierRange:peek()
    local m_rgpQuestStack = self.rgpQuestStack
    local pCurQuestProp = m_rgpQuestStack[#m_rgpQuestStack]

    local pQuestProp = nil
    if pCurQuestProp ~= nil then
        local rgpAccs = ctAccessors:get_accessors_by_active_requirements(pCurQuestProp, nil)
        if self:_should_fetch_quest(pCurQuestProp, rgpAccs) then
            pQuestProp = pCurQuestProp
        end
    end

    return pQuestProp
end

function CQuestFrontierRange:_fetch_from_nodes(pCurQuestProp, rgpAccs)
    local m_tpPropTypeQuests = self.tpPropTypeQuests

    for _, pAcc in pairs(rgpAccs) do
        local pNode = m_tpPropTypeQuests[pAcc]
        pNode:remove(pCurQuestProp)
    end
end

function CQuestFrontierRange:fetch()
    local m_rgpQuestStack = self.rgpQuestStack

    local pQuestProp = table.remove(m_rgpQuestStack)

    local rgpAccs = ctAccessors:get_accessors_by_active_requirements(pQuestProp, nil)
    self:_fetch_from_nodes(pQuestProp, rgpAccs)

    return pQuestProp
end

function CQuestFrontierRange:count()
    local m_tpPropTypeQuests = self.tpPropTypeQuests

    local tRet = {}
    for pAcc, m_pNode in pairs(m_tpPropTypeQuests) do
        local iCount = m_pNode:count()
        table.insert(tRet, iCount)
    end

    return tRet
end
