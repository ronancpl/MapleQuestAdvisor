--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("router.procedures.constant")
require("utils.struct.class")
require("utils.struct.stack")

CTracePath = createClass({
    pRootLane,
    pStackLane = SStack:new(),
    pStackProp = SStack:new()
})

function CTracePath:load(pLane)
    self.pRootLane = pLane
    self.pStackLane:export(U_INT_MAX)
    self.pStackProp:export(U_INT_MAX)
end

function CTracePath:get_paths()
    local rgpPaths = self.pRootLane:get_paths()
    return rgpPaths
end

function CTracePath:get_sublanes()
    local rgpLanes = self.pRootLane:get_sublanes()
    return rgpLanes
end

function CTracePath:_push_lane(pQuestProp, pLane)
    self.pStackLane:push(pLane)
    self.pStackProp:push(pQuestProp)

    self.pRootLane = pLane
end

function CTracePath:_pop_lane()
    local pLane = self.pStackLane:pop()
    self.pStackProp:pop()

    self.pRootLane = pLane
end

function CTracePath:move_ahead(pQuestProp)
    local m_pRootLane = self.pRootLane

    local pLane = m_pRootLane:get_sublane(pQuestProp)
    if pLane ~= nil then
        self:_push_lane(pQuestProp, pLane)
        return true
    else
        return false
    end
end

function CTracePath:move_back()
    self:_pop_lane()
end
