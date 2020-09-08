--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("utils.class");
require("utils.print");

STable = createClass({tpItems = {}, __LENGTH = 0})

function STable:is_empty()
    return self.__LENGTH == 0
end

function STable:size()
    return self.__LENGTH
end

function STable:get(pKey)
    local m_tpItems = self.tpItems
    return m_tpItems[pKey]
end

function STable:get_entry_set()
    local tpItems = {}
    for k, v in pairs(self.tpItems) do
        tpItems[k] = v
    end

    return tpItems
end

function STable:remove(pKey)
    local m_tpItems = self.tpItems

    local pRemoved = m_tpItems[pKey]
    if pRemoved ~= nil then
        m_tpItems[pKey] = nil
        self.__LENGTH = self.__LENGTH - 1
    end

    return pRemoved
end

function STable:insert(pKey, pValue)
    local pRemoved = self:remove(pKey)
    if pRemoved == nil then
        self.__LENGTH = self.__LENGTH + 1
    end

    local m_tpItems = self.tpItems
    m_tpItems[pKey] = pValue
    return pRemoved
end

function STable:_insert(tTable)
    for k, v in pairs(tTable) do
        self:insert(k, v)
    end
end

function STable:insert(tTable)
    if type(tTable) == "table" then
        if tTable.__LENGTH ~= nil then
            self:_insert(tTable:get_entry_set())
        else
            self:_insert(tTable)
        end
    end
end

function STable:printable()
    local m_tpItems = self.tpItems
    printable(m_tpItems)
end
