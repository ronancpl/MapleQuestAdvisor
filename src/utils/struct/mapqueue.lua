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

SMapQueue = createClass({
    tpQueues = {}
})

function SMapQueue:_get_queue(pKey)
    local m_tpQueues = self.tpQueues
    return m_tpQueues[pKey]
end

function SMapQueue:peek(pKey)
    local pQueue = self:_get_queue(pKey)
    return pQueue:peek()
end

function SMapQueue:get_size(pKey)
    local pQueue = self:_get_queue(pKey)
    return pQueue:size()
end

function SMapQueue:push(pKey, pItem)
    local pQueue = self:_get_queue(pKey)
    pQueue:push(pItem)
end

function SMapQueue:poll(pKey)
    local pQueue = self:_get_queue(pKey)
    local pItem = pQueue:poll()

    return pItem
end

function SMapQueue:init(rgpKeys)
    local m_tpQueues = self.tpQueues

    for _, pKey in ipairs(rgpKeys) do
        local rgpQueue = SQueue:new()
        m_tpQueues[pKey] = rgpQueue
    end
end
