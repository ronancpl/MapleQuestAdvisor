--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("utils.procedure.set")
require("utils.struct.array")
require("utils.struct.class")
local SSet = require("pl.class").Set

CNeighborPool = createClass({
    tAccQuests = {},
    tPropQuests = {},
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
    local m_tPropQuests = self.tPropQuests

    for _, pQuestProp in ipairs(rgpPoolProps) do
        local rgpAccs = ctAccessors:get_accessors_by_active_requirements(pQuestProp)
        for _, pAcc in ipairs(rgpAccs) do
            local pQuestChkProp = pQuestProp:get_requirement()

            m_tAccQuests[pAcc]:add(pQuestChkProp)
            m_tPropQuests[pQuestChkProp] = pQuestProp
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

local function fn_compare_player_invt(pAcc)
    local fn_get_property = pAcc:get_fn_property()
    return function(a, iSeized)
        return #(fn_get_property(a)) - iSeized
    end
end

local function fn_compare_player_unit(pAcc)
    local fn_get_property = pAcc:get_fn_property()
    return function(a, iSeized)
        return fn_get_property(a) - iSeized
    end
end

local function fn_get_quest_property(pAcc)
    local fn_get_property = pAcc:get_fn_property()
    return function(a)
        return fn_get_property(a)
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

function CNeighborPool:_init_last_player_props(ctAccessors)
    local m_pLastPlayerProps = self.pLastPlayerProps

    local rgpAccInvts
    local rgpAccUnits

    rgpAccInvts, rgpAccUnits = ctAccessors:get_accessor_range_keys()
    for _, pAcc in ipairs(rgpAccInvts) do
        m_pLastPlayerProps[pAcc] = {}
    end

    for _, pAcc in ipairs(rgpAccUnits) do
        m_pLastPlayerProps[pAcc] = 0
    end
end

function CNeighborPool:init(ctAccessors, rgpPoolProps)
    self:_init_table(ctAccessors)
    self:_init_quests(rgpPoolProps, ctAccessors)
    self:_sort_tables(ctAccessors)

    self:_init_last_player_props(ctAccessors)
end

function CNeighborPool:update_player_props(pExploredQuestProp)
    local m_pLastPlayerProps = self.pLastPlayerProps

    local rgpAccs = ctAccessors:get_accessors_by_active_requirements(pExploredQuestProp)

    local pQuestChkProp = pExploredQuestProp:get_requirement()
    for _, pAcc in ipairs(rgpAccs) do
        local fn_get_property = pAcc:get_fn_property()
        m_pLastPlayerProps[pAcc] = fn_get_property(pQuestChkProp)
    end
end

function CNeighborPool:_adjust_accessor_neighbor_limits(pAcc, bInvt, iSt, iEn, iCurProp, iLastProp, bReverse)
    local rgAccPool = self.tAccQuests[pAcc]

    local iStProp
    local iEnProp
    if bReverse then
        iStProp = iLastProp
        iEnProp = iCurProp
    else
        iStProp = iCurProp
        iEnProp = iLastProp
    end

    local fn_get_prop = fn_get_quest_property(pAcc)
    local pStPoolProp = rgAccPool:get(iSt)
    if pStPoolProp == nil or (bInvt and #fn_get_prop(pStPoolProp) or fn_get_prop(pStPoolProp)) < iStProp then     -- prop values are within range of iStProp ~ iEnProp
        iSt = iSt + 1
    end

    local pEnPoolProp = rgAccPool:get(iEn)
    if pEnPoolProp == nil or (bInvt and #fn_get_prop(pEnPoolProp) or fn_get_prop(pEnPoolProp)) > iEnProp then
        iEn = iEn - 1
    end

    return iSt, iEn
end

function CNeighborPool:_fetch_accessor_neighbor_candidates(pAcc, fn_compare_player_prop, bInvt, pPlayerState)
    local rgpNeighbors = {}

    local fn_player_property = pAcc:get_fn_player_property()

    local pCurProp = fn_player_property(pPlayerState)
    local iCurProp = bInvt and #pCurProp or pCurProp

    local m_pLastPlayerProps = self.pLastPlayerProps
    local pLastProp = m_pLastPlayerProps[pAcc]
    local iLastProp = bInvt and #pLastProp or pLastProp

    local rgAccPool = self.tAccQuests[pAcc]

    local iStateIdx
    local iLastIdx

    local iSt
    local iEn
    local bReverse

    if iLastProp <= iCurProp then
        iStateIdx = rgAccPool:bsearch(fn_compare_player_prop(pAcc), iCurProp, true, false)
        iLastIdx = rgAccPool:bsearch(fn_compare_player_prop(pAcc), iLastProp, true, true)

        iSt = iLastIdx
        iEn = iStateIdx
        bReverse = false
    else
        iStateIdx = rgAccPool:bsearch(fn_compare_player_prop(pAcc), iCurProp, true, true)
        iLastIdx = rgAccPool:bsearch(fn_compare_player_prop(pAcc), iLastProp, true, false)

        iSt = iStateIdx
        iEn = iLastIdx
        bReverse = true
    end

    iSt, iEn = self:_adjust_accessor_neighbor_limits(pAcc, bInvt, iSt, iEn, iCurProp, iLastProp, bReverse)
    local rgpNeighbors = rgAccPool:slice(iSt, iEn)
    return SSet{unpack(rgpNeighbors:list())}, bReverse
end

function CNeighborPool:_fetch_updated_accessors_slices(rgpInvtAccs, rgpUnitAccs, pPlayerState)
    local tAccSlices = {}

    for _, pAcc in ipairs(rgpInvtAccs) do
        local pAccNeighborsSlice = self:_fetch_accessor_neighbor_candidates(pAcc, fn_compare_player_invt, true, pPlayerState)
        tAccSlices[pAcc] = pAccNeighborsSlice
    end

    for _, pAcc in ipairs(rgpUnitAccs) do
        local pAccNeighborsSlice = self:_fetch_accessor_neighbor_candidates(pAcc, fn_compare_player_unit, false, pPlayerState)
        tAccSlices[pAcc] = pAccNeighborsSlice
    end

    return tAccSlices
end

function CNeighborPool:_create_updated_accessors_set(tAccSlices)
    local tpSetAccWithdrawn = {}
    local tpSetAccAdditional = {}

    for pAcc, tSlice in pairs(tAccSlices) do
        local pSetNeighbors
        local bReverse

        pSetNeighbors, bReverse = tSlice
        if bReverse then
            tpSetAccWithdrawn[pAcc] = pSetNeighbors
        else
            tpSetAccAdditional[pAcc] = pSetNeighbors
        end
    end

    return tpSetAccWithdrawn, tpSetAccAdditional
end

function CNeighborPool:fetch_updated_accessors_set(rgpInvtAccs, rgpUnitAccs, pPlayerState)
    local tAccSlices = self:_fetch_updated_accessors_slices(rgpInvtAccs, rgpUnitAccs, pPlayerState)

    local tpSetAccWithdrawn
    local tpSetAccAdditional
    tpSetAccWithdrawn, tpSetAccAdditional = self:_create_updated_accessors_set(tAccSlices)

    return tpSetAccWithdrawn, tpSetAccAdditional
end

function CNeighborPool:fetch_remaining_neighbors(pSetCurNeighbors, tpSetAccWithdrawn)
    local pSet = collection_copy(pSetCurNeighbors)

    for _, pSetWithdrawn in pairs(tpSetAccWithdrawn) do
        pSet = pSet - pSetWithdrawn
    end

    return pSet
end

function CNeighborPool:_fetch_full_additional_set(tpSetAccProps)
    local pSetFull = SSet{}
    for _, pSetProps in pairs(tpSetAccProps) do
        pSetFull = pSetFull + pSetProps
    end

    return pSetFull
end

function CNeighborPool:_fetch_accessor_additionals_table(tpSetAccProps)
    local tpAccAdditionals = {}

    for pAcc, pSetProps in pairs(tpSetAccProps) do
        local pAccAdditionals = {}

        for _, pQuestProps in ipairs(pSetProps:values()) do
            pAccAdditionals[pQuestProps] = 1
        end

        tpAccAdditionals[pAcc] = pAccAdditionals
    end

    return tpAccAdditionals
end

function CNeighborPool:_is_additional_neighbor(ctAccessors, tpAccAdditionals, pQuestProp, pQuestProps)
    local rgpAccs = ctAccessors:get_accessors_by_active_requirements(pQuestProp)

    for _, pAcc in ipairs(rgpAccs) do
        local tpAdditionalNeighbors = tpAccAdditionals[pAcc]
        if tpAdditionalNeighbors ~= nil then
            if tpAdditionalNeighbors[pQuestProps] == nil then
                return false
            end
        end
    end

    return true
end

function CNeighborPool:fetch_additional_neighbors(ctAccessors, tpSetAccAdditional)
    local rgpAdditionalNeighbors = {}

    local pSetFull = self:_fetch_full_additional_set(tpSetAccAdditional)
    local tpAccAdditionals = self:_fetch_accessor_additionals_table(tpSetAccAdditional)

    local m_tPropQuests = self.tPropQuests
    for _, pQuestProps in ipairs(pSetFull:values()) do
        local pQuestProp = m_tPropQuests[pQuestProps]

        if self:_is_additional_neighbor(ctAccessors, tpAccAdditionals, pQuestProp, pQuestProps) then
            table.insert(rgpAdditionalNeighbors, pQuestProp)
        end
    end

    return SSet{unpack(rgpAdditionalNeighbors)}
end
