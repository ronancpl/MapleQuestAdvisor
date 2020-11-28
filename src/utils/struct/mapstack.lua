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
require("utils.struct.stack")

SMapStack = createClass({
    tpStacks = {}
})

function SMapStack:_get_stack(pKey)
    local m_tpStacks = self.tpStacks
    return m_tpStacks[pKey]
end

function SMapStack:get_top(pKey)
    local pStack = self:_get_stack(pKey)
    return pStack:get_top()
end

function SMapStack:push(pKey, pItem)
    local pStack = self:_get_stack(pKey)
    pStack:push(pItem)
end

function SMapStack:pop(pKey)
    local pStack = self:_get_stack(pKey)
    local pItem = pStack:pop()

    return pItem
end

function SMapStack:init(rgpKeys)
    local m_tpStacks = self.tpStacks

    for _, pKey in pairs(rgpKeys) do
        local rgpStack = {}
        m_tpStacks[pKey] = rgpStack
    end
end
