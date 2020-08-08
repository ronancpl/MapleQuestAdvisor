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

SArray = createClass({rgpItems = {}})

function SArray:isEmpty()
    return #m_rgpItems == 0
end

function SArray:add(pItem)
    local m_rgpItems = self.rgpItems
    local nItems = #m_rgpItems

    m_rgpItems[nItems + 1] = pItem
end

function SArray:remove(iIdxStart, iIdxEnd)
    local m_rgpItems = self.rgpItems
    local nItems = #m_rgpItems

    iIdxEnd = iIdxEnd or nItems

    rgpRemoved = SArray:new()
    local nRemoved = iIdxEnd - iIdxStart

    for i = 1, nRemoved, 1 do
        local iIdxCur = iIdxStart + i - 1
        rgpRemoved:add(m_rgpItems[iIdxCur])
    end

    local N = math.min(nItems - (iIdxEnd + 1), nRemoved)
    for i = 1, N, 1 do
        local iIdxCur = iIdxStart + i - 1
        m_rgpItems[iIdxCur] = m_rgpItems[iIdxEnd + i]
    end

    for i = N, nRemoved, 1 do
        local iIdxCur = iIdxStart + i - 1
        m_rgpItems[iIdxCur] = nil
    end

    return rgpRemoved
end

function SArray:removeLast()
    local m_rgpItems = self.rgpItems
    local nLastIdx = #m_rgpItems

    remove(nLastIdx)
end

function SArray:sort(fn_sort)
    local m_rgpItems = self.rgpItems

    if fn_sort then
        tables.sort(m_rgpItems, fn_sort)
    else
        tables.sort(m_rgpItems)
    end
end

function SArray:randomize()     -- Algorithm: Fisher-Yates
    local m_rgpItems = self.rgpItems
    local nRgpItems = #m_rgpItems

    for i = 1, nRgpItems, 1 then
        local j = math.random(1, #nRgpItems)

        local temp = m_rgpItems[j]
        m_rgpItems[j] = m_rgpItems[i]
        m_rgpItems[i] = temp
    end
end

function SArray:find(fn_select)
    local m_rgpItems = self.rgpItems
    local nRgpItems = #m_rgpItems

    rgpFilter = SArray:new()

    for i = 1, nRgpItems, 1 then
        if fn_select(m_rgpItems[i]) then
            rgpFilter:add(m_rgpItems[i])
        end
    end

    return rgpFilter
end

local function SArray:find_first_from(fn_compare, iIdx, pToFind)
    local m_rgpItems = self.rgpItems

    local i = iIdx
    while i > 0 do
        i -= 1
        if fn_compare(m_rgpItems[i], pToFind) ~= 0 then
            i += 1
            break
        end
    end

    return i
end

function SArray:bsearch(fn_compare, pToFind, bReturnPos, bFirstMatch)
    local m_rgpItems = self.rgpItems
    local nRgpItems = #m_rgpItems

    local st = 1, en = nRgpItems + 1

    while st < en do
        local m = math.ceil((st + en) / 2)

        local pMid = m_rgpItems[m]
        local sResult = fn_compare(pMid, pToFind)

        if sResult == 0 then
            if bFirstMatch then
                m = find_first_from(fn_compare, m, pToFind)
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
