--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("router.route")
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

function CTracePath:get_root_lane()
    return self.pRootLane
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
    local pQuestProp = self.pStackProp:pop()

    self.pRootLane = pLane

    return pQuestProp
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
    return self:_pop_lane()
end

function CTracePath:trim_back()
    local m_pStackLane = self.pStackLane
    local nLanes = m_pStackLane:size()

    for i = 1, nLanes - RWndConfig.TRACK.MAX_BEHIND_TO_RETURN, 1 do
        m_pStackLane:pop_fifo()
    end
end

function CTracePath:_route_ahead(pPlayerState, pPath)
    local pPlayerCopy = pPlayerState:clone()

    local rgpQuestProps = pPath:list()
    local pLastQuestProp = table.remove(rgpQuestProps)

    local pSublane = self:get_root_lane()
    local _, pQuestProp in ipairs(rgpQuestProps) do
        progress_player_state(ctAwarders, pQuestProp, pPlayerCopy, {})
        pSublane = pSublane:get_sublane(pQuestProp)
    end

    progress_player_state(ctAwarders, pLastQuestProp, pPlayerCopy, {})
    local pRouteLane, _, _ = generate_quest_route(pPlayerCopy)

    self:add_sublane(pLastQuestProp, pRouteLane)
end

function CTracePath:look_ahead(pPlayerState, bBroadcastLookahead)
    if bBroadcastLookahead then
        for _, pPath in ipairs(self:get_paths()) do
            local nQuestsAhead = pPath:size()
            if nQuestsAhead < RWndConfig.TRACK.MAX_AHEAD_TO_SEARCH then
                self:_route_ahead(pPlayerState, pPath)
            end
        end
    else
        local nQuestsAhead = U_INT_MIN
        for _, pPath in ipairs(self:get_paths()) do
            nQuestsAhead = math.max(nQuestsAhead, pPath:size())
        end

        if nQuestsAhead < RWndConfig.TRACK.MAX_AHEAD_TO_SEARCH then
            self:_route_ahead(pPlayerState, self.pRootLane:get_path())
        end
    end
end

function CTracePath:to_string()
    local st = ""
    for _, pQuestProp in ipairs(self.pStackProp:list()) do
        st = st .. pQuestProp:get_name() .. ", "
    end

    st = st .. " >> ["
    for pQuestProp, _ in pairs(self.pRootLane:get_sublanes()) do
        st = st .. pQuestProp:get_name() .. ", "
    end
    st = st .. "]"

    return st
end
