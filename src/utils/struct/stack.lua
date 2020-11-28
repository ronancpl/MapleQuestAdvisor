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

SStack = createClass({
    rgpItems = {}
})

function SStack:get_top()
    local m_rgpItems = self.rgpItems
    return m_rgpItems[#m_rgpItems]
end

function SStack:push(pItem)
    local m_rgpItems = self.rgpItems
    table.insert(m_rgpItems, pItem)
end

function SStack:pop()
    local m_rgpItems = self.rgpItems
    local pItem = table.remove(m_rgpItems)

    return pItem
end
