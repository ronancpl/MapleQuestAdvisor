--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("utils.struct.class")
require("utils.struct.queue")
require("utils.struct.stack")

SBeltStack = createClass({
    pStack = SStack:new(),
    pRunning = SQueue:new()
})

function SBeltStack:push(pItem)
    self.pStack:push(pItem)
end

function SBeltStack:poll()
    local pItem = self.pRunning:poll()
    if pItem == nil then
        pItem = self.pStack:pop()
    end

    return pItem
end

function SBeltStack:peek()
    local pItem = self.pStack:pop()
    self.pRunning:push(pItem)

    return pItem
end

function SBeltStack:export(iLimitCount)
    local rgpItems = {}

    local m_pRunning = self.pRunning
    iLimitCount = math.min(iLimitCount, m_pRunning:size())
    for i = 1, iLimitCount, 1 do
        local pItem = m_pRunning:poll()
        table.insert(rgpItems, pItem)
    end

    return rgpItems
end
