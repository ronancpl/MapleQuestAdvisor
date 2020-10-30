--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("router.structs.neighbor.pool")
require("utils.procedure.set")
require("utils.struct.array")
require("utils.struct.class")
local SSet = require("pl.class").Set

CNeighborArranger = createClass({
    tpUpdatedInvtAccs = {},
    tpUpdatedUnitAccs = {},
    pCurrentNeighborsSet = SSet{},
    pQuestPool = CNeighborPool:new()
})

function CNeighborArranger:init(ctAccessors, rgpPoolProps)
    local m_tpUpdatedInvtAccs = self.tpUpdatedInvtAccs
    local m_tpUpdatedUnitAccs = self.tpUpdatedUnitAccs

    local rgpAccInvts
    local rgpAccUnits
    rgpAccInvts, rgpAccUnits = ctAccessors:get_accessor_range_keys()
    for _, pAcc in ipairs(rgpAccInvts) do
        m_tpUpdatedInvtAccs[pAcc] = 1
    end

    for _, pAcc in ipairs(rgpAccUnits) do
        m_tpUpdatedUnitAccs[pAcc] = 1
    end

    local m_pQuestPool = self.pQuestPool
    m_pQuestPool:init(ctAccessors, rgpPoolProps)
end

function CNeighborArranger:_fetch_visit_updated_requirements()
    local rgpUpdatedInvtAccs = {}
    for pAcc, _ in pairs(self.tpUpdatedInvtAccs) do
        table.insert(rgpUpdatedInvtAccs, pAcc)
    end
    self.tpUpdatedInvtAccs = {}

    local rgpUpdatedUnitAccs = {}
    for pAcc, _ in pairs(self.tpUpdatedUnitAccs) do
        table.insert(rgpUpdatedUnitAccs, pAcc)
    end
    self.tpUpdatedUnitAccs = {}

    return rgpUpdatedInvtAccs, rgpUpdatedUnitAccs
end

function CNeighborArranger:_fetch_explored_updated_requirements(ctAccessors, pExploredQuestProp, bInvt)
    local rgpAccs = {}

    for _, pAcc in ipairs(ctAccessors:get_accessors_by_active_requirements(pExploredQuestProp, bInvt)) do
        if pAcc:is_supply_handler() then
            table.insert(rgpAccs, pAcc)
        end
    end

    return rgpAccs
end

function CNeighborArranger:update_visit(ctAccessors, pPlayerState, pExploredQuestProp)
    local m_pQuestPool = self.pQuestPool
    local m_tpCurrentNeighbors = self.pCurrentNeighborsSet

    local rgpUpdatedInvtAccs
    local rgpUpdatedUnitAccs
    rgpUpdatedInvtAccs, rgpUpdatedUnitAccs = self:_fetch_visit_updated_requirements()

    local rgpExploredInvtAccs = self:_fetch_explored_updated_requirements(ctAccessors, pExploredQuestProp, true)
    local rgpExploredUnitAccs = self:_fetch_explored_updated_requirements(ctAccessors, pExploredQuestProp, false)

    local pUpdatedInvtAccsSet = SSet{unpack(rgpExploredInvtAccs)} + SSet{unpack(rgpUpdatedInvtAccs)}
    local pUpdatedUnitAccsSet = SSet{unpack(rgpExploredUnitAccs)} + SSet{unpack(rgpUpdatedUnitAccs)}

    local rgpInvtAccs = collection_values(pUpdatedInvtAccsSet)
    local rgpUnitAccs = collection_values(pUpdatedUnitAccsSet)

    local tAccWithdrawnSet
    local tAccAdditionalSet
    tAccWithdrawnSet, tAccAdditionalSet = m_pQuestPool:fetch_updated_accessors_set(rgpInvtAccs, rgpUnitAccs, pPlayerState)

    local pRemainingSet = m_pQuestPool:fetch_remaining_neighbors(m_tpCurrentNeighbors, tAccWithdrawnSet)
    local pAdditionalSet = m_pQuestPool:fetch_additional_neighbors(ctAccessors, tAccAdditionalSet)

    self.pCurrentNeighborsSet = pRemainingSet + pAdditionalSet
    m_pQuestPool:update_player_props(pExploredQuestProp)

    return collection_values(self.pCurrentNeighborsSet)
end

function CNeighborArranger:rollback_visit(ctAccessors, pExploredQuestProp)
    local m_tpUpdatedInvtAccs = self.tpUpdatedInvtAccs
    for _, pAcc in ipairs(ctAccessors:get_accessors_by_active_requirements(pExploredQuestProp, true)) do
        m_tpUpdatedInvtAccs[pAcc] = 1
    end

    local m_tpUpdatedUnitAccs = self.tpUpdatedUnitAccs
    for _, pAcc in ipairs(ctAccessors:get_accessors_by_active_requirements(pExploredQuestProp, false)) do
        m_tpUpdatedUnitAccs[pAcc] = 1
    end
end
