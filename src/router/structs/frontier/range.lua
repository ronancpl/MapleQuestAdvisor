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
require("utils.array")
require("utils.class")
require("utils.table")

CQuestFrontierRange = createClass({
    tpPropTypeQuests = {},
    rgsPropTypeKeys = SArray:new()
})

function CQuestFrontierRange:_init_accessor_type(sAccName, CQuestRangeType, fn_get_player_property)
    local m_tpPropTypeQuests = self.tpPropTypeQuests
    m_tpPropTypeQuests[sAccName] = CQuestRangeType:new({fn_player_property = fn_get_player_property})

    local m_rgsPropTypeKeys = self.rgsPropTypeKeys
    m_rgsPropTypeKeys:add(sAccName)
end

function CQuestFrontierRange:init(tsAccUnits, tsAccInvts)
    for sAccName, fn_get_player_property in pairs(tsAccUnits) do
        self:_init_accessor_type(sAccName, CQuestFrontierUnit, fn_get_player_property)
    end

    for sAccName, fn_get_player_property in pairs(tsAccInvts) do
        self:_init_accessor_type(sAccName, CQuestFrontierList, fn_get_player_property)
    end
end

function CQuestFrontierRange:_add_to_node(pAcc, pQuestProp, pQuestChkProp, CQuestRangeType)
    local m_tpPropTypeQuests = self.tpPropTypeQuests
    local sAccName = pAcc:get_name()

    local pTypeRange = m_tpPropTypeQuests[sAccName]
    pTypeRange:add(pAcc, pQuestProp, pQuestChkProp)
end

function CQuestFrontierRange:add(pQuestProp, ctAccessors)
    local rgfn_active_check_unit
    local rgfn_active_check_invt
    rgfn_active_check_unit, rgfn_active_check_invt, pQuestChkProp = pQuestProp:get_rgfn_active_requirements()

    for _, fn_get in ipairs(rgfn_active_check_invt) do
        local pAcc = ctAccessors:get_accessor_by_fn_get(fn_get)
        if pAcc ~= nil then
            self:_add_to_node(pAcc, pQuestProp, pQuestChkProp, CQuestFrontierList)
        end
    end

    for _, fn_get in ipairs(rgfn_active_check_unit) do
        local pAcc = ctAccessors:get_accessor_by_fn_get(fn_get)
        if pAcc ~= nil then
            self:_add_to_node(pAcc, pQuestProp, pQuestChkProp, CQuestFrontierUnit)
        end
    end
end

function CQuestFrontierRange:update_take(pPlayerState, bSelect)
    local m_tpPropTypeQuests = self.tpPropTypeQuests
    local tpTakeQuestProps = STable:new()

    for sAccName, tpQuestProps in pairs(m_tpPropTypeQuests) do
        local rgpQuestProps = tpQuestProps:update_take(pPlayerState, bSelect)
        tpTakeQuestProps:insert(sAccName, rgpQuestProps)
    end

    return tpTakeQuestProps
end

function CQuestFrontierRange:update_put(tpTakeQuestProps)
    local m_tpPropTypeQuests = self.tpPropTypeQuests

    for sAccName, rgpQuestProps in pairs(tpTakeQuestProps:get_entry_set()) do
        local tpQuestProps = m_tpPropTypeQuests[sAccName]
        tpQuestProps:update_put(rgpQuestProps)
    end
end

function CQuestFrontierRange:_fetch_from_nodes()
    local m_rgsKeys = self.rgsPropTypeKeys
    m_rgsKeys:randomize()

    local m_tpPropTypeQuests = self.tpPropTypeQuests
    local pFrontierProp = nil
    local i = 1
    local nKeys = m_rgsKeys:size()
    while pFrontierProp == nil and i <= nKeys do
        local pNode = m_tpPropTypeQuests[m_rgsKeys:get(i)]
        i = i + 1

        pFrontierProp = pNode:fetch()
    end

    local pQuestProp = nil
    if pFrontierProp ~= nil then
        pQuestProp = pFrontierProp:get_quest_properties()
    end

    return pQuestProp
end

function CQuestFrontierRange:fetch()
    return self:_fetch_from_nodes()
end
