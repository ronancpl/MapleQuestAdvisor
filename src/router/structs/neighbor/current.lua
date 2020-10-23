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

CNeighborOngoing = createClass({
    rgpCurrentNeighbors = {}
})

function CNeighborOngoing:init()

end

function CNeighborOngoing:_remove_neighbors()
    local rgpNeighbors = {}

    local rgpAccs = ctAccessors:get_accessors_by_active_requirements(pQuestProp)
    for _, pAcc in ipairs(rgpAccs) do

    end

    return rgpNeighbors
end

function CNeighborOngoing:_add_neighbors()
    local rgpNeighbors = {}

    local rgpAccs = ctAccessors:get_accessors_by_active_requirements(pQuestProp)
    for _, pAcc in ipairs(rgpAccs) do

    end

    return rgpNeighbors
end

function CNeighborOngoing:push_visit(pPlayerState, pQuestProp)

end

function CNeighborOngoing:pop_visit()

end
