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
require("utils.procedure.print")
require("utils.procedure.sort")

SArray = createClass({apItems = {}})

function SArray:is_empty()
    local m_apItems = self.apItems
    return #m_apItems == 0
end

function SArray:size()
    local m_apItems = self.apItems
    return #m_apItems
end

function SArray:list()
    local m_apItems = self.apItems

    local rgItems = {}
    for _, v in pairs(m_apItems) do
        table.insert(rgItems, v)
    end

    return rgItems
end

function SArray:get(iIdx)
    local m_apItems = self.apItems
    return m_apItems[iIdx]
end

function SArray:get_last()
    local m_apItems = self.apItems
    local iLastIdx = #m_apItems

    return self:get(iLastIdx)
end

function SArray:add(pItem)
    local m_apItems = self.apItems
    local nItems = #m_apItems

    m_apItems[nItems + 1] = pItem
end

function SArray:add_all(rgpItems)
    if type(rgpItems) == "table" then
        local m_apItems = self.apItems
        local nItems = #m_apItems

        local rgpList = rgpItems.apItems ~= nil and rgpItems:list() or rgpItems

        local nList = #rgpList
        for i = 1, nList, 1 do
            m_apItems[nItems + i] = rgpList[i]
        end
    end
end

function SArray:remove(iIdxStart, iIdxEnd)
    local m_apItems = self.apItems
    local nItems = #m_apItems

    iIdxEnd = (iIdxEnd or nItems) <= nItems and iIdxEnd or nItems

    local apRemoved = SArray:new()
    for i = iIdxStart, iIdxEnd, 1 do
        apRemoved:add(m_apItems[i])
    end

    local iIdxRight = iIdxEnd + 1
    local nLeft = nItems - iIdxRight + 1
    for i = 0, nLeft - 1, 1 do
        m_apItems[iIdxStart + i] = m_apItems[iIdxRight + i]
    end

    for i = iIdxStart + nLeft, nItems, 1 do
        m_apItems[i] = nil
    end

    return apRemoved
end

function SArray:remove_last()
    local m_apItems = self.apItems
    local iLastIdx = #m_apItems

    local apRemoved = self:remove(iLastIdx)
    if not apRemoved:is_empty() then
        return apRemoved:get(1)
    else
        return nil
    end
end

function SArray:remove_all()
    local m_apItems = self.apItems

    local nItems = #m_apItems
    for i = 1, nItems, 1 do
        m_apItems[i] = nil
    end
end

function SArray:sort(fn_sort)
    local m_apItems = self.apItems

    if fn_sort then
        local tTable
        local bArray

        tTable, bArray = spairs_table(m_apItems)
        local rgpPairs = spairs(tTable, fn_sort)

        self:remove_all()   -- clear array, next insert sorted
        local iOpt = bArray and 1 or 2
        for _, pPair in ipairs(rgpPairs) do
            local pItem = pPair[iOpt]
            table.insert(m_apItems, pItem)
        end
    else
        table.sort(m_apItems)
    end
end

function SArray:reverse()
    local rgTempArray = SArray:new()
    rgTempArray:add_all(self)

    self:remove_all()

    local rgTempItems = rgTempArray:list()
    for i = #rgTempItems, 1, -1 do
        self:add(rgTempItems[i])
    end
end

function SArray:randomize()     -- Algorithm: Fisher-Yates
    local m_apItems = self.apItems
    local napItems = #m_apItems

    for i = 1, napItems, 1 do
        local j = math.random(1, napItems)

        local temp = m_apItems[j]
        m_apItems[j] = m_apItems[i]
        m_apItems[i] = temp
    end
end

function SArray:find(fn_select)
    local m_apItems = self.apItems
    local napItems = #m_apItems

    local apFilter = SArray:new()

    for i = 1, napItems, 1 do
        if fn_select(m_apItems[i]) then
            apFilter:add(m_apItems[i])
        end
    end

    return apFilter
end

function SArray:_find_first_from(fn_compare, iIdx, pToFind)
    local m_apItems = self.apItems

    local i = iIdx - 1
    while i > 0 do
        if fn_compare(m_apItems[i], pToFind) ~= 0 then
            break
        end

        i = i - 1
    end

    return i + 1
end

function SArray:_find_last_from(fn_compare, iIdx, pToFind)
    local m_apItems = self.apItems

    local i = iIdx
    while i <= #m_apItems do
        i = i + 1

        if fn_compare(m_apItems[i], pToFind) ~= 0 then
            break
        end
    end

    return i - 1
end

function SArray:bsearch(fn_compare, pToFind, bReturnPos, bFirstMatch)
    local m_apItems = self.apItems
    local napItems = #m_apItems

    local st = 1
    local en = napItems

    if napItems > 0 then
        while st <= en do
            local m = math.ceil((st + en) / 2)

            local pMid = m_apItems[m]
            local sResult = fn_compare(pMid, pToFind)

            if sResult == 0 then
                if bFirstMatch ~= nil then
                    if bFirstMatch then
                        m = self:_find_first_from(fn_compare, m, pToFind)
                    else
                        m = self:_find_last_from(fn_compare, m, pToFind)
                    end
                end

                return m
            elseif sResult < 0 then
                st = m + 1
            else
                en = m - 1
            end
        end

        return bReturnPos and ((fn_compare(m_apItems[napItems], pToFind) > 0) and en or en + 1) or 0
    else
        return bReturnPos and 1 or 0
    end
end

function SArray:index_of(fn_select, bFromStart)
    local m_apItems = self.apItems
    local napItems = #m_apItems

    local it = bFromStart and {1, napItems, 1} or {napItems, 1, -1}
    for i = it[1], it[2], it[3] do
        if fn_select(m_apItems[i]) then
            return i
        end
    end

    return -1
end

function SArray:slice(iFromIdx, iToIdx)
    local rgpNew = SArray:new()

    local m_apItems = self.apItems
    for i = iFromIdx, iToIdx, 1 do
        local pItem = m_apItems[i]
        rgpNew:add(pItem)
    end

    return rgpNew
end

function SArray:insert(pItem, iFromIdx)
    local rgpSlice = iFromIdx ~= nil and self:remove(iFromIdx) or SArray:new()
    self:add(pItem)
    self:add_all(rgpSlice)
end

function SArray:insert_array(rgpArray, iFromIdx)
    local rgpSlice = iFromIdx ~= nil and self:remove(iFromIdx) or SArray:new()
    self:add_all(rgpArray)
    self:add_all(rgpSlice)
end

function SArray:printable()
    local m_apItems = self.apItems

    for _, pItem in pairs(m_apItems) do
        printable(pItem)
    end
end
