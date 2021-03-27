--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("router.procedures.constant")
require("utils.struct.class")

SQueue = createClass({
    tpItems = {},
    __ST = 1,
    __EN = 1,
    __LENGTH = U_QUEUE_SIZE_INC
})

function SQueue:_get_prev_bound(iIdx)
    return (((iIdx - 1) - 1) % (self.__LENGTH)) + 1
end

function SQueue:_get_next_bound(iIdx)
    return (((iIdx - 1) + 1) % (self.__LENGTH)) + 1
end

function SQueue:_remove(iSt, iEn)
    local rgpRetItems = {}

    local m_tpItems = self.tpItems
    for i = iSt, iEn, 1 do
        table.insert(rgpRetItems, m_tpItems[i])
        m_tpItems[i] = nil
    end

    return rgpRetItems
end

function SQueue:_clear()
    self.tpItems = {}
    self.__ST = 1
    self.__EN = 1
end

function SQueue:_add_all(rgpItems)
    local m_tpItems = self.tpItems

    local iIdx = #m_tpItems
    for i, pItem in ipairs(rgpItems) do
        m_tpItems[iIdx + i] = pItem
    end
end

function SQueue:_resize()
    local iIdxSt = self.__ST
    local iIdxEn = self.__EN
    local iLen = self.__LENGTH

    local iIdxLeftEn
    local iIdxRightEn
    if iIdxSt > iIdxEn then
        iIdxLeftEn = self:_get_prev_bound(iLen)
        iIdxRightEn = iIdxEn - 1
    else
        iIdxLeftEn = self:_get_prev_bound(iIdxEn)
        iIdxRightEn = 0
    end

    local rgpItemsRight = self:_remove(iIdxSt, iIdxLeftEn)
    local rgpItemsLeft = self:_remove(1, iIdxRightEn)

    self:_clear()     -- reestablish elements in a bigger queue
    self.__LENGTH = self.__LENGTH + U_QUEUE_SIZE_INC

    self:_add_all(rgpItemsRight)
    self:_add_all(rgpItemsLeft)

    local nItems = #self.tpItems
    self.__ST = 1
    self.__EN = 1 + nItems

    while self.__LENGTH < self.__EN do
        self.__LENGTH = self.__LENGTH + U_QUEUE_SIZE_INC
    end
end

function SQueue:push(pItem)
    local iNext = self:_get_next_bound(self.__EN)
    if iNext == self.__ST then
        self:_resize()
        iNext = self:_get_next_bound(self.__EN)
    end

    local m_tpItems = self.tpItems
    m_tpItems[self.__EN] = pItem

    self.__EN = iNext
end

function SQueue:poll()
    if self.__ST == self.__EN then
        return nil
    end

    local m_tpItems = self.tpItems
    local pItem = m_tpItems[self.__ST]
    local iNext = self:_get_next_bound(self.__ST)

    self.__ST = iNext
    return pItem
end

function SQueue:peek()
    if self.__ST == self.__EN then
        return nil
    end

    local m_tpItems = self.tpItems
    local pItem = m_tpItems[self.__ST]

    return pItem
end

local function append_items_to_list(rgpToAdd, tpItems, iFromIdx, iToIdx)
    for i = iFromIdx, iToIdx, 1 do
        table.insert(rgpToAdd, tpItems[i])
    end
end

function SQueue:list()
    local rgpItems = {}

    if self.__ST <= self.__EN then
        append_items_to_list(rgpItems, self.tpItems, self.__ST, self.__EN - 1)
    else
        append_items_to_list(rgpItems, self.tpItems, self.__ST, self.__LENGTH)
        append_items_to_list(rgpItems, self.tpItems, 1, self.__EN - 1)
    end

    return rgpItems
end

function SQueue:size()
    if self.__ST <= self.__EN then
        local nRhs = self.__EN - self.__ST
        return nRhs
    else
        local nLhs = self.__EN - 1
        local nRhs = (self.__LENGTH + 1) - self.__ST
        return nLhs + nRhs
    end
end

function SQueue:printable()
    local iEnL
    local iEnR

    if self.__ST > self.__EN then
        iEnL = self.__LENGTH
        iEnR = self.__EN - 1
    else
        iEnL = self.__EN - 1
        iEnR = 0
    end

    print("[")
    for i = self.__ST, iEnL, 1 do
        printable(q.tpItems[i])
    end

    for i = 1, iEnR, 1 do
        printable(q.tpItems[i])
    end
    print("]")
end
