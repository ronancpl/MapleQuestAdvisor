--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

SMapStack = createClass({
    tpStacks = {}
})

function SMapStack:get_top(pKey)
    local m_tpStacks = self.tpStacks

    local rgpStack = m_tpStacks[pKey]
    return rgpStack[#rgpStack]
end

function SMapStack:push(pKey, pItem)
    local m_tpStacks = self.tpStacks

    local rgpStack = m_tpStacks[pKey]
    table.insert(rgpStack, pItem)
end

function SMapStack:pop(pKey)
    local m_tpStacks = self.tpStacks

    local rgpStack = m_tpStacks[pKey]
    local pItem = table.remove(rgpStack)

    return pItem
end

function SMapStack:init(rgpKeys)
    local m_tpStacks = self.tpStacks

    for _, pKey in pairs(rgpKeys) do
        local rgpStack = {}
        m_tpStacks[pKey] = rgpStack
    end
end
