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

SStack = createClass({
    rgpItems = {}
})

function SStack:get_top()
    local m_rgpItems = self.rgpItems
    return m_rgpItems[#m_rgpItems]
end

function SStack:size()
    local m_rgpItems = self.rgpItems
    return #m_rgpItems
end

function SStack:push(pItem)
    local m_rgpItems = self.rgpItems
    table.insert(m_rgpItems, pItem)
end

function SStack:push_all(rgpItems)
    if type(rgpItems) == "table" then
        local rgpList = rgpItems.apItems ~= nil and rgpItems:list() or rgpItems
        for _, pItem in ipairs(rgpList) do
            self:push(pItem)
        end
    end
end

function SStack:pop()
    local m_rgpItems = self.rgpItems
    local pItem = table.remove(m_rgpItems)

    return pItem
end

function SStack:pop_fifo()
    local m_rgpItems = self.rgpItems
    local pItem = table.remove(m_rgpItems, 1)

    return pItem
end

function SStack:export(iLimitCount)
    iLimitCount = math.min(iLimitCount, self:size())

    local rgpItems = {}
    for i = 1, iLimitCount, 1 do
        local pItem = self:pop()
        table.insert(rgpItems, pItem)
    end

    return rgpItems
end

function SStack:list()
    local m_rgpItems = self.rgpItems

    local rgpItems = {}
    for _, pItem in ipairs(m_rgpItems) do
        table.insert(rgpItems, pItem)
    end

    return rgpItems
end
