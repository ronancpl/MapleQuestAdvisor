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
require("utils.quest")
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

function CQuestFrontierRange:_add_to_node(pAcc, pQuestProp, CQuestRangeType)
    local m_tpPropTypeQuests = self.tpPropTypeQuests
    local sAccName = pAcc:get_name()

    local fn_compare = CQuestRangeType.get_fn_compare()
    local fn_create = CQuestRangeType.get_fn_create()
    local fn_get_property = pAcc:get_fn_pending()
    m_tpPropTypeQuests[sAccName]:add(pQuestProp, fn_compare, fn_create, fn_get_property)
end

function CQuestFrontierRange:add(pQuestProp, ctAccessors)
    local rgsPropInvts = pQuestProp:get_properties_keys_invt()
    for _, sAccName in ipairs(rgsPropInvts) do
        local pAcc = ctAccessors:get_accessor_by_name(sAccName)
        self:_add_to_node(pAcc, pQuestProp, CQuestFrontierList)
    end

    local rgsPropUnits = pQuestProp:get_properties_keys_unit()
    for _, sAccName in ipairs(rgsPropUnits) do
        local pAcc = ctAccessors:get_accessor_by_name(sAccName)
        self:_add_to_node(pAcc, pQuestProp, CQuestFrontierUnit)
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
    local pQuestProp = nil
    local i = 1
    local nKeys = m_rgsKeys:size()
    while pQuestProp == nil and i <= nKeys do
        local pNode = m_tpPropTypeQuests[m_rgsKeys:get(i)]
        i = i + 1

        pQuestProp = pNode:fetch()
    end

    return pQuestProp
end

function CQuestFrontierRange:fetch()
    return self:_fetch_from_nodes()
end
