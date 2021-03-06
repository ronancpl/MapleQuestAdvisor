--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

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
    local m_tpPropTypeQuests = self.tpPropTypeQuests

    for _, pAcc in ipairs(rgpAccUnits) do
        self:_init_accessor_type(pAcc, CQuestFrontierUnit)
        m_tpPropTypeQuests[pAcc].fn_comparing = m_tpPropTypeQuests[pAcc]:get_fn_compare()
    end

    for _, pAcc in ipairs(rgpAccInvts) do
        self:_init_accessor_type(pAcc, CQuestFrontierList)
        m_tpPropTypeQuests[pAcc].fn_comparing = m_tpPropTypeQuests[pAcc]:get_fn_compare()
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

    for pAcc, pTypeRange in pairs(m_tpPropTypeQuests) do
        local rgpFrontierProps = pTypeRange:update_take(pPlayerState, bSelect)

        tpTakeQuestProps:insert(pAcc, rgpFrontierProps)
        self:_exchange_quests(rgpFrontierProps, false)
    end

    return tpTakeQuestProps
end

function CQuestFrontierRange:update_put(pPlayerState, tpTakeQuestProps, bSelect)
    local m_tpPropTypeQuests = self.tpPropTypeQuests

    for pAcc, rgpQuestProps in pairs(tpTakeQuestProps:get_entry_set()) do
        local pTypeRange = m_tpPropTypeQuests[pAcc]

        pTypeRange:update_put(pPlayerState, rgpQuestProps, bSelect)
        self:_exchange_quests(rgpQuestProps, true)
    end
end

function CQuestFrontierRange:prepare_range(pPlayerState)
    local m_tpPropTypeQuests = self.tpPropTypeQuests

    for _, pTypeRange in pairs(m_tpPropTypeQuests) do
        pTypeRange:update_prepare(pPlayerState)
    end
end

function CQuestFrontierRange:normalize_range()
    local m_tpPropTypeQuests = self.tpPropTypeQuests

    for _, pTypeRange in pairs(m_tpPropTypeQuests) do
        pTypeRange:update_normalize()
    end
end

function CQuestFrontierRange:_remove_from_nodes(pQuestProp)
    local m_tpPropTypeQuests = self.tpPropTypeQuests
    for _, pTypeRange in pairs(m_tpPropTypeQuests) do
        pTypeRange:remove(pQuestProp)
    end
end

function CQuestFrontierRange:should_fetch_quest(pQuestProp)
    local rgpAccs = ctAccessors:get_accessors_by_active_requirements(pQuestProp, nil)
    if #rgpAccs > 0 then
        local m_tpPropTypeQuests = self.tpPropTypeQuests

        for _, pAcc in ipairs(rgpAccs) do
            if ctAccessors:is_prerequisite_strong(pAcc) then
                local pTypeRange = m_tpPropTypeQuests[pAcc]
                if not pTypeRange:contains(pQuestProp) then     -- meaning any of the strong requisites have not been met by player
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
    for pAcc, pTypeRange in pairs(m_tpPropTypeQuests) do
        for _, pFrontierProp in ipairs(pTypeRange:list()) do
            local pQuestProp = pFrontierProp:get_property()
            tQuests[pQuestProp] = (tQuests[pQuestProp] or 0) + 1
        end
    end

    local st = ""
    for pQuestProp, _ in pairs(tQuests) do
        st = st .. pQuestProp:get_name(true) .. ":" .. (_ / #ctAccessors:get_accessors_by_active_requirements(pQuestProp)) .. ", "
    end

    print(sType .. "HAVE [" .. st .. "]")
end

function CQuestFrontierRange:_fetch_from_nodes(pCurQuestProp, rgpAccs)
    local m_tpPropTypeQuests = self.tpPropTypeQuests

    for _, pAcc in pairs(rgpAccs) do
        local pTypeRange = m_tpPropTypeQuests[pAcc]
        pTypeRange:remove(pCurQuestProp)
    end
end

function CQuestFrontierRange:fetch(pQuestProp)
    local rgpAccs = ctAccessors:get_accessors_by_active_requirements(pQuestProp, nil)
    self:_fetch_from_nodes(pQuestProp, rgpAccs)
end

function CQuestFrontierRange:count()
    local m_tpPropTypeQuests = self.tpPropTypeQuests

    local tRet = {}
    for pAcc, pTypeRange in pairs(m_tpPropTypeQuests) do
        local iCount = pTypeRange:count()
        tRet[pAcc] = iCount
    end

    return tRet
end
