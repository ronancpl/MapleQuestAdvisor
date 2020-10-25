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
    local rgpAccInvts
    local rgpAccUnits

    local m_tpUpdatedInvtAccs = self.tpUpdatedInvtAccs
    local m_tpUpdatedUnitAccs = self.tpUpdatedUnitAccs
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

function CNeighborArranger:update_visit(ctAccessors, pPlayerState, pExploredQuestProp)
    local m_pQuestPool = self.pQuestPool
    local m_tpCurrentNeighbors = self.pCurrentNeighborsSet

    local rgpUpdatedInvtAccs
    local rgpUpdatedUnitAccs
    rgpUpdatedInvtAccs, rgpUpdatedUnitAccs = self:_fetch_visit_updated_requirements()

    local pUpdatedInvtAccsSet = SSet{ctAccessors:get_accessors_by_active_requirements(pExploredQuestProp, true)} + SSet{unpack(rgpUpdatedInvtAccs)}
    local pUpdatedUnitAccsSet = SSet{ctAccessors:get_accessors_by_active_requirements(pExploredQuestProp, false)} + SSet{unpack(rgpUpdatedUnitAccs)}

    local rgpInvtAccs = pUpdatedInvtAccsSet:values()
    local rgpUnitAccs = pUpdatedUnitAccsSet:values()

    local pRemainingSet = m_pQuestPool:fetch_remaining_neighbors(m_tpCurrentNeighbors, pPlayerState, rgpInvtAccs, rgpUnitAccs)
    local pAdditionalSet = m_pQuestPool:fetch_additional_neighbors(pPlayerState, rgpInvtAccs, rgpUnitAccs)

    self.pCurrentNeighborsSet = pRemainingSet + pAdditionalSet
    return self.pCurrentNeighborsSet:values()
end

function CNeighborArranger:rollback_visit(ctAccessors, pExploredQuestProp)
    local m_tpUpdatedAccs = self.tpUpdatedAccs

    for _, pAcc in ipairs(ctAccessors:get_accessors_by_active_requirements(pExploredQuestProp)) do
        m_tpUpdatedAccs[pAcc] = 1
    end
end
