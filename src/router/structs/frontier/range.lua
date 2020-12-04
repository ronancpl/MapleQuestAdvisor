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
    tpQuests = {}
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

function CQuestFrontierRange:_exchange_quests(rgpQuestProps, bCheckIn)
    local iCheckInVal = bCheckIn and 1 or nil   -- insert or remove from table

    local m_tpQuests = self.tpQuests
    for _, pQuestProp in ipairs(rgpQuestProps) do
        m_tpQuests[pQuestProp] = iCheckInVal
    end
end

function CQuestFrontierRange:add(pQuestProp, ctAccessors)
    local pQuestChkProp = pQuestProp:get_requirement()

    for _, pAcc in ipairs(ctAccessors:get_accessors_by_active_requirements(pQuestProp, true)) do
        self:_add_to_node(pAcc, pQuestProp, pQuestChkProp, CQuestFrontierList)
    end

    for _, pAcc in ipairs(ctAccessors:get_accessors_by_active_requirements(pQuestProp, false)) do
        self:_add_to_node(pAcc, pQuestProp, pQuestChkProp, CQuestFrontierUnit)
    end

    self:_exchange_quests({pQuestProp}, true)
end

function CQuestFrontierRange:contains(pQuestProp)
    local m_tpQuests = self.tpQuests
    return m_tpQuests[pQuestProp] ~= nil
end

function CQuestFrontierRange:update_take(pPlayerState, bSelect)
    local m_tpPropTypeQuests = self.tpPropTypeQuests
    local tpTakeQuestProps = STable:new()

    for pAcc, tpQuestProps in pairs(m_tpPropTypeQuests) do
        local rgpQuestProps = tpQuestProps:update_take(pPlayerState, bSelect)

        tpTakeQuestProps:insert(pAcc, rgpQuestProps)
        self:_exchange_quests(rgpQuestProps, false)
    end

    return tpTakeQuestProps
end

function CQuestFrontierRange:update_put(tpTakeQuestProps, bSelect)
    local m_tpPropTypeQuests = self.tpPropTypeQuests

    for pAcc, rgpQuestProps in pairs(tpTakeQuestProps:get_entry_set()) do
        local tpQuestProps = m_tpPropTypeQuests[pAcc]

        tpQuestProps:update_put(rgpQuestProps)
        self:_exchange_quests(rgpQuestProps, true)
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
            if ctAccessors:is_prerequisite_strong(pAcc) then
                local pNode = m_tpPropTypeQuests[pAcc]
                if not pNode:contains(pCurQuestProp) then     -- meaning any of the strong requisites have not been met by player
                    return false
                end
            end
        end
    end

    return true
end

function CQuestFrontierRange:debug_front(sType)
    local tQuests = {}

    local m_tpPropTypeQuests = self.tpPropTypeQuests
    for pAcc, tpQuestProps in pairs(m_tpPropTypeQuests) do
        for _, pFrontierProp in ipairs(tpQuestProps:list()) do
            local pQuestProp = pFrontierProp:get_property()
            tQuests[pQuestProp] = 1
        end
    end

    local st = ""
    for pQuestProp, _ in pairs(tQuests) do
        st = st .. pQuestProp:get_name(true) .. ", "
    end

    print(sType .. "HAVE [" .. st .. "]")
end

function CQuestFrontierRange:_fetch_from_nodes(pCurQuestProp, rgpAccs)
    local m_tpPropTypeQuests = self.tpPropTypeQuests

    for _, pAcc in pairs(rgpAccs) do
        local pNode = m_tpPropTypeQuests[pAcc]
        pNode:remove(pCurQuestProp)
    end
end

function CQuestFrontierRange:fetch(pQuestProp)
    local rgpAccs = ctAccessors:get_accessors_by_active_requirements(pQuestProp, nil)
    self:_fetch_from_nodes(pQuestProp, rgpAccs)
end

function CQuestFrontierRange:count()
    local m_tpPropTypeQuests = self.tpPropTypeQuests

    local tRet = {}
    for pAcc, m_pNode in pairs(m_tpPropTypeQuests) do
        local iCount = m_pNode:count()
        tRet[pAcc] = iCount
    end

    return tRet
end
