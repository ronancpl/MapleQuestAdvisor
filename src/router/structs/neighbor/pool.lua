--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("utils.struct.array")
require("utils.struct.class")
local SSet = require("pl.class").Set

CNeighborPool = createClass({
    tAccQuests = {},
    rgpAllQuests = {},
    pLastPlayerProps = {}
})

function CNeighborPool:_init_table(ctAccessors)
    local rgpAccInvts
    local rgpAccUnits

    rgpAccInvts, rgpAccUnits = ctAccessors:get_accessor_range_keys()
    local m_tAccQuests = self.tAccQuests

    for _, pAcc in ipairs(rgpAccInvts) do
        m_tAccQuests[pAcc] = SArray:new()
    end

    for _, pAcc in ipairs(rgpAccUnits) do
        m_tAccQuests[pAcc] = SArray:new()
    end
end

function CNeighborPool:_init_quests(rgpPoolProps, ctAccessors)
    local m_tAccQuests = self.tAccQuests
    local m_rgpAllQuests = self.rgpAllQuests
    for _, pQuestProp in ipairs(rgpPoolProps:list()) do
        local rgpAccs = ctAccessors:get_accessors_by_active_requirements(pQuestProp)
        for _, pAcc in ipairs(rgpAccs) do
            m_tAccQuests[pAcc]:add(pQuestProp)
        end

        table.insert(m_rgpAllQuests, pQuestProp)
    end
end

local function fn_compare_invt(pAcc)
    local fn_get_property = pAcc:get_fn_property()
    return function(a, b)
        return #(fn_get_property(a)) < #(fn_get_property(b))
    end
end

local function fn_compare_unit(pAcc)
    local fn_get_property = pAcc:get_fn_property()
    return function(a, b)
        return fn_get_property(a) < fn_get_property(b)
    end
end

local function fn_compare_player_invt(pAcc, iSeized)
    local fn_get_property = pAcc:get_fn_property()
    return function(a)
        return iSeized - #(pAcc:fn_get_property(a))
    end
end

local function fn_compare_player_unit(pAcc, iSeized)
    local fn_get_property = pAcc:get_fn_property()
    return function(a)
        return iSeized - fn_get_property(a)
    end
end

function CNeighborPool:_sort_tables(ctAccessors)
    local rgpAccInvts
    local rgpAccUnits

    rgpAccInvts, rgpAccUnits = ctAccessors:get_accessor_range_keys()
    for _, pAcc in ipairs(rgpAccInvts) do
        self.tAccQuests[pAcc]:sort(fn_compare_invt(pAcc))
    end

    for _, pAcc in ipairs(rgpAccUnits) do
        self.tAccQuests[pAcc]:sort(fn_compare_unit(pAcc))
    end
end

function CNeighborPool:init(ctAccessors, rgpPoolProps)
    self:_init_table(ctAccessors)
    self:_init_quests(rgpPoolProps, ctAccessors)
    self:_sort_tables(ctAccessors)
end

function CNeighborPool:_update_player_props(pExploredQuestProp)
    local m_pLastPlayerProps = self.pLastPlayerProps

    local rgpAccs = ctAccessors:get_accessors_by_active_requirements(pExploredQuestProp)
    for _, pAcc in ipairs(rgpAccs) do
        m_pLastPlayerProps[pAcc] = pAcc:fn_get_property(pExploredQuestProp)
    end
end

function CNeighborPool:_fetch_accessor_neighbor_candidates(pAcc, fn_compare_player_prop, bInvt, pPlayerState)
    local rgpNeighbors = {}

    local fn_player_property = pAcc:get_fn_player_property()

    local pCurProp = fn_player_property(pPlayerState)
    local iCurProp = bInvt and #pCurProp or pCurProp

    local m_pLastPlayerProps = self.pLastPlayerProps
    local iLastProp = m_pLastPlayerProps[pAcc]

    local m_tAccQuests = self.tAccQuests
    local rgPool = m_tAccQuests[pAcc]

    local iStateIdx = rgPool:bsearch(fn_compare_player_prop(pAcc, iCurProp), pCurProp)
    local iLastIdx = rgPool:bsearch(fn_compare_player_prop(pAcc, iLastProp), pLastProp)

    local iSt
    local iEn
    if iStateIdx > iLastIdx then
        iSt = iLastIdx
        iEn = iStateIdx
    else
        iSt = iStateIdx
        iEn = iLastIdx
    end

    local rgpNeighbors = rgPool:slice(iSt, iEn)
    return SSet{unpack(rgpNeighbors)}
end

function CNeighborPool:fetch_remaining_neighbors(tpCurrentQuests, pPlayerState, rgpInvtAccs, rgpUnitAccs)
    local pSet = SSet{unpack(tpCurrentQuests:values())} -- todo set from set

    for _, pAcc in ipairs(rgpInvtAccs) do
        pSet = SSet.intersection(pSet, self:_fetch_accessor_neighbor_candidates(pAcc, fn_compare_player_invt, true, pPlayerState))
    end

    for _, pAcc in ipairs(rgpUnitAccs) do
        pSet = SSet.intersection(pSet, self:_fetch_accessor_neighbor_candidates(pAcc, fn_compare_player_unit, false, pPlayerState))
    end

    return pSet
end

function CNeighborPool:fetch_additional_neighbors(pPlayerState, rgpInvtAccs, rgpUnitAccs)
    local m_rgpAllQuests = self.rgpAllQuests
    local pSet = SSet{unpack(m_rgpAllQuests)}

    for _, pAcc in ipairs(rgpInvtAccs) do
        pSet = SSet.intersection(pSet, self:_fetch_accessor_neighbor_candidates(pAcc, fn_compare_player_invt, true, pPlayerState))
    end

    for _, pAcc in ipairs(rgpUnitAccs) do
        pSet = SSet.intersection(pSet, self:_fetch_accessor_neighbor_candidates(pAcc, fn_compare_player_unit, false, pPlayerState))
    end

    return pSet
end
