--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("utils.struct.class")
require("utils.struct.queue")

SBeltQueue = createClass({
    pQueue = SQueue:new(),
    pRunning = SQueue:new()
})

function SBeltQueue:push(pItem)
    self.pQueue:push(pItem)
end

function SBeltQueue:poll()
    local pItem = self.pRunning:poll()
    if pItem == nil then
        pItem = self.pQueue:poll()
    end

    return pItem
end

function SBeltQueue:peek()
    local pItem = self.pQueue:poll()
    self.pRunning:push(pItem)

    return pItem
end

function SBeltQueue:export()
    local rgpItems = {}

    local m_pRunning = self.pRunning
    while true do
        local pItem = m_pRunning:poll()
        if pItem == nil then
            break
        end

        table.insert(rgpItems, pItem)
    end

    return rgpItems
end
