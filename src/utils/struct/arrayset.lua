--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("utils.struct.array")
require("utils.struct.class")

SArraySet = createClass({
    rgpItems = SArray:new(),
    tpSetItems = {}
})

function SArraySet:add(pItem)
    local m_rgpItems = self.rgpItems
    local m_tpSetItems = self.tpSetItems

    if m_tpSetItems[pItem] == nil then
        table.insert(m_rgpItems, pItem)
        m_tpSetItems[pItem] = #m_rgpItems
    end
end

function SArraySet:remove(pItem)
    local m_rgpItems = self.rgpItems
    local m_tpSetItems = self.tpSetItems

    local iIdx = m_tpSetItems[pItem]
    if iIdx ~= nil then
        m_tpSetItems[pItem] = nil
        table.remove(m_rgpItems, iIdx)
    end
end

function SArraySet:get(iIdx)
    local m_rgpItems = self.rgpItems
    return m_rgpItems[iIdx]
end

function SArraySet:size()
    local m_rgpItems = self.rgpItems
    return #m_rgpItems
end

function SArraySet:list()
    local m_rgpItems = self.rgpItems
    return m_rgpItems
end
