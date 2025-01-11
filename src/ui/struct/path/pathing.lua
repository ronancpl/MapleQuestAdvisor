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
require("ui.constant.config")
require("utils.struct.class")
require("utils.struct.stack")

CTracePath = createClass({
    pRootLane,
    pStackLane = SStack:new(),
    pStackProp = SStack:new(),

    bTrimmed = false
})

function CTracePath:load(pLane)
    self.pRootLane = pLane
    self.pStackLane:export(U_INT_MAX)
    self.pStackProp:export(U_INT_MAX)
end

function CTracePath:get_root_lane()
    return self.pRootLane
end

function CTracePath:get_top_quest()
    local pQuestProp = self.pStackProp:get_top()
    return pQuestProp
end

function CTracePath:get_paths()
    local rgpPaths = self.pRootLane:get_paths()
    return rgpPaths
end

function CTracePath:get_recommended_paths()
    local rgpPaths = self.pRootLane:get_recommended_paths()
    return rgpPaths
end

function CTracePath:get_sublanes()
    local rgpLanes = self.pRootLane:get_sublanes()
    return rgpLanes
end

function CTracePath:_push_lane(pQuestProp, pLane)
    self.pStackLane:push(self.pRootLane)
    self.pStackProp:push(pQuestProp)

    self.pRootLane = pLane
end

function CTracePath:_pop_lane()
    local pLane = self.pStackLane:pop()
    local pQuestProp = self.pStackProp:pop()

    self.pRootLane = pLane

    return pQuestProp
end

function CTracePath:get_top_lane()
    local pQuestProp = self.pStackLane:get_top()
    return pQuestProp
end

function CTracePath:is_ahead(pQuestProp)
    local m_pRootLane = self.pRootLane
    return m_pRootLane:get_sublane(pQuestProp) ~= nil
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
    if self.pStackLane:size() > (self.bTrimmed and 1 or 0) then
        return self:_pop_lane()
    else
        return nil
    end
end

function CTracePath:trim_back()
    local m_pStackLane = self.pStackLane

    local nLanesTrim = m_pStackLane:size() - RWndConfig.TRACK.MAX_BEHIND_TO_RETURN
    if nLanesTrim > 0 then
        for i = 1, nLanesTrim, 1 do
            m_pStackLane:pop_fifo()
        end

        self.bTrimmed = true
    end
end

function CTracePath:_route_fetch_path_follow_ahead(pPath)
    local rgpQuestProps = pPath:list()

    local pSublane = self:get_root_lane()

    local i = 0
    for _, pQuestProp in ipairs(rgpQuestProps) do
        pSublane = pSublane:get_sublane(pQuestProp)
        if pSublane == nil then
            break
        end

        i = i + 1
    end

    local rgpFollowQuestProps = {}
    for j = 1, i, 1 do
        table.insert(rgpFollowQuestProps, rgpQuestProps[j])
    end
    return rgpFollowQuestProps
end

function CTracePath:_route_ahead(pPlayerState, pPath)
    local pPlayerCopy = pPlayerState:clone()

    local rgpQuestProps = self:_route_fetch_path_follow_ahead(pPath)    -- prune quest path not found in lane
    if #rgpQuestProps > 1 then
        local pLastQuestProp = table.remove(rgpQuestProps)

        local pSublane = self:get_root_lane()
        for _, pQuestProp in ipairs(rgpQuestProps) do
            progress_player_state(ctAwarders, pQuestProp, pPlayerCopy, {})
            pSublane = pSublane:get_sublane(pQuestProp)
        end

        progress_player_state(ctAwarders, pLastQuestProp, pPlayerCopy, {})
        local pRouteLane = generate_quest_route(pPlayerCopy, pUiWmap)

        pSublane:add_sublane(pLastQuestProp, pRouteLane)
    end
end

function CTracePath:look_ahead(pPlayerState, bBroadcastLookahead)
    if bBroadcastLookahead then
        for _, pSubpath in ipairs(self:get_paths()) do
            local nQuestsAhead = pSubpath:size()
            if nQuestsAhead < RWndConfig.TRACK.MAX_AHEAD_TO_SEARCH then
                self:_route_ahead(pPlayerState, pSubpath)
            end
        end
    else
        local nQuestsAhead = U_INT_MIN
        local pPath = nil
        for _, pSubpath in ipairs(self:get_paths()) do
            if nQuestsAhead < pSubpath:size() then
                pPath = pSubpath
                nQuestsAhead = pSubpath:size()
            end
        end

        if pPath ~= nil and nQuestsAhead < RWndConfig.TRACK.MAX_AHEAD_TO_SEARCH then
            self:_route_ahead(pPlayerState, pPath)
        end
    end
end

function CTracePath:to_string()
    local st = "["
    for _, pQuestProp in ipairs(self.pStackProp:list()) do
        st = st .. pQuestProp:get_name() .. ", "
    end
    st = st .. "] >> " .. self.pRootLane:to_string()

    return st
end
