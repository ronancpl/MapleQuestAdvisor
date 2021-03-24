--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("utils.procedure.copy")
require("utils.procedure.unpack")
require("utils.struct.array")
require("utils.struct.class")

SArraySet = createClass({
    apItems = SArray:new(),
    tpSetItems = {}
})

function SArraySet:add(pItem)
    local m_apItems = self.apItems
    local m_tpSetItems = self.tpSetItems

    if m_tpSetItems[pItem] == nil then
        m_apItems:add(pItem)
        m_tpSetItems[pItem] = m_apItems:size()
    end
end

function SArraySet:_rearrange_keys(iFromIdx)
    local m_tpSetItems = self.tpSetItems

    local tSetItems = table_copy(m_tpSetItems)
    for pItem, iIdx in pairs(tSetItems) do
        if iIdx > iFromIdx then
            m_tpSetItems[pItem] = iIdx - 1
        end
    end
end

function SArraySet:_rebuild_keys()
    local m_tpSetItems = self.tpSetItems

    local rgpItems = self.apItems:list()
    for i = 1, #rgpItems, 1 do
        local pItem = rgpItems[i]
        m_tpSetItems[pItem] = i
    end
end

function SArraySet:remove(pItem)
    local m_apItems = self.apItems
    local m_tpSetItems = self.tpSetItems

    local iIdx = m_tpSetItems[pItem]
    if iIdx ~= nil then
        m_tpSetItems[pItem] = nil
        m_apItems:remove(iIdx, iIdx)
        self:_rearrange_keys(iIdx)
    end
end

function SArraySet:remove_all()
    local m_apItems = self.apItems
    local rgpItems = m_apItems:remove_all()

    local m_tpSetItems = self.tpSetItems
    clear_table(m_tpSetItems)

    return rgpItems
end

function SArraySet:get(iIdx)
    local m_apItems = self.apItems
    return m_apItems:get(iIdx)
end

function SArraySet:size()
    local m_apItems = self.apItems
    return m_apItems:size()
end

function SArraySet:list()
    local m_apItems = self.apItems
    return m_apItems:list()
end

function SArraySet:sort(fn_sort)
    local m_apItems = self.apItems
    m_apItems:sort(fn_sort)

    self:_rebuild_keys()
end
