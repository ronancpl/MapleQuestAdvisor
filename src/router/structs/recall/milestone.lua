--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("router.structs.recall.storage")
require("utils.struct.class")

CGraphMilestone = createClass({
    tMilestone = {},
    pStorage = CGraphMilestoneStorage:new()
})

function CGraphMilestone:get_subpath(rgpNeighbors)
    local m_pStorage = self.pStorage
    local iOidNeighbors = m_pStorage:get(rgpNeighbors)

    return self.tMilestone[iOidNeighbors]
end

function CGraphMilestone:add_subpath(rgpNeighbors)
    local m_pStorage = self.pStorage
    local iOidNeighbors = m_pStorage:get(rgpNeighbors)

    self.tMilestone[iOidNeighbors] = 1
end
