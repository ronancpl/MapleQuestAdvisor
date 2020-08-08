--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require "utils/class";

SArray = createClass({apItems = {}})

function SArray:isEmpty()
    return #m_apItems == 0
end

function SArray:add(pItem)
    local m_apItems = self.apItems
    local nItems = #m_apItems

    m_apItems[nItems + 1] = pItem
end

function SArray:remove(iIdxStart, iIdxEnd)
    local m_apItems = self.apItems
    local nItems = #m_apItems

    iIdxEnd = iIdxEnd or nItems

    apRemoved = SArray:new()
    local nRemoved = iIdxEnd - iIdxStart

    for i = 1, nRemoved, 1 do
        local iIdxCur = iIdxStart + i - 1
        apRemoved:add(m_apItems[iIdxCur])
    end

    local N = math.min(nItems - (iIdxEnd + 1), nRemoved)
    for i = 1, N, 1 do
        local iIdxCur = iIdxStart + i - 1
        m_apItems[iIdxCur] = m_apItems[iIdxEnd + i]
    end

    for i = N, nRemoved, 1 do
        local iIdxCur = iIdxStart + i - 1
        m_apItems[iIdxCur] = nil
    end

    return apRemoved
end

function SArray:removeLast()
    local m_apItems = self.apItems
    local nLastIdx = #m_apItems

    remove(nLastIdx)
end

function SArray:sort(fn_sort)
    local m_apItems = self.apItems

    if fn_sort then
        tables.sort(m_apItems, fn_sort)
    else
        tables.sort(m_apItems)
    end
end

function SArray:randomize()     -- Algorithm: Fisher-Yates
    local m_apItems = self.apItems
    local napItems = #m_apItems

    for i = 1, napItems, 1 then
        local j = math.random(1, #napItems)

        local temp = m_apItems[j]
        m_apItems[j] = m_apItems[i]
        m_apItems[i] = temp
    end
end

function SArray:find(fn_select)
    local m_apItems = self.apItems
    local napItems = #m_apItems

    apFilter = SArray:new()

    for i = 1, napItems, 1 then
        if fn_select(m_apItems[i]) then
            apFilter:add(m_apItems[i])
        end
    end

    return apFilter
end

local function SArray:find_first_from(fn_compare, iIdx, pToFind)
    local m_apItems = self.apItems

    local i = iIdx
    while i > 0 do
        i -= 1
        if fn_compare(m_apItems[i], pToFind) ~= 0 then
            i += 1
            break
        end
    end

    return i
end

local function SArray:find_last_from(fn_compare, iIdx, pToFind)
    local m_apItems = self.apItems

    local i = iIdx
    while i <= #m_apItems do
        i += 1
        if fn_compare(m_apItems[i], pToFind) ~= 0 then
            i -= 1
            break
        end
    end

    return i
end

function SArray:bsearch(fn_compare, pToFind, bReturnPos, bFirstMatch)
    local m_apItems = self.apItems
    local napItems = #m_apItems

    local st = 1, en = napItems + 1

    while st < en do
        local m = math.ceil((st + en) / 2)

        local pMid = m_apItems[m]
        local sResult = fn_compare(pMid, pToFind)

        if sResult == 0 then
            if bFirstMatch ~= nil then
                if bFirstMatch then
                    m = find_first_from(fn_compare, m, pToFind)
                else then
                    m = find_last_from(fn_compare, m, pToFind)
                end
            end

            return m
        else if sResult < 0 then
            st = m + 1
        else then
            en = m - 1
        end
    end

    return if bReturnPos then en else 0
end
