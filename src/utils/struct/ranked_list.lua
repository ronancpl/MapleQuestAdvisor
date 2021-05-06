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
require("utils.struct.array")
require("utils.struct.class")

SRankedSet = createClass({
    rgpItems = SArray:new(),
    tpItPos = {},
    tpItVal = {},
    nCapacity = 0,
    iBoundaryVal = U_INT_MIN
})

function SRankedSet:_get_base_value()
    return self.iBoundaryVal
end

function SRankedSet:_reset_base_value()
    self.iBoundaryVal = U_INT_MIN
end

function SRankedSet:_set_base_value(iVal)
    self.iBoundaryVal = iVal
end

function SRankedSet:get_boundary()
    return self.nCapacity
end

function SRankedSet:set_boundary(iCap)
    if iCap < self:get_boundary() then
        self:_reset_base_value()
    end

    self.nCapacity = iCap
end

function SRankedSet:contains(pItem)
    local m_tpItPos = self.tpItPos
    return m_tpItPos[pItem] ~= nil
end

function SRankedSet:_amend_positions(iPos, iDlt)
    local m_tpItPos = self.tpItPos

    for pItem, iIdx in pairs(m_tpItPos) do
        local iItPos = iIdx
        if iItPos >= iPos then
            m_tpItPos[pItem] = iItPos + iDlt
        end
    end

    local st = ""
    for k, v in pairs(m_tpItPos) do
        st = st .. tostring(k) .. ":" .. tostring(v) .. ","
    end
    print("F:" .. iPos .. " >>> [" .. st .. "]")
end

function SRankedSet:_remove(pItem)
    local m_tpItPos = self.tpItPos

    local iIdx = m_tpItPos[pItem]
    if iIdx ~= nil then
        local m_tpItVal = self.tpItVal
        local m_rgpItems = self.rgpItems

        m_tpItPos[pItem] = nil
        m_tpItVal[pItem] = nil
        m_rgpItems:remove(iIdx, iIdx)

        self:_amend_positions(iIdx + 1, -1)

        if m_rgpItems:size() < self:get_boundary() then
            self:_reset_base_value()
        end
    end
end

function SRankedSet:remove(pItem)
    self:_remove(pItem)
end

function SRankedSet:_get_fn_item_position()
    return function(pItem, iVal)
        local m_tpItVal = self.tpItVal
        return (m_tpItVal[pItem] or -1) - iVal
    end
end

function SRankedSet:add(pItem, iVal)
    self:_reset_base_value()

    if self:contains(pItem) then
        self:_remove(pItem)
    end

    if iVal > self:_get_base_value() then
        local m_rgpItems = self.rgpItems

        local m_tpItVal = self.tpItVal
        m_tpItVal[pItem] = iVal

        local fn_compare_item_pos = self:_get_fn_item_position()
        local iIdx = m_rgpItems:bsearch(fn_compare_item_pos, iVal, true, true)

        local m_tpItPos = self.tpItPos
        m_tpItPos[pItem] = iIdx

        self:_amend_positions(iIdx + 1, 1)

        m_rgpItems:insert(pItem, iIdx)

        local nSize = m_rgpItems:size()
        if nSize > self:get_boundary() then
            local pItm = m_rgpItems:get_last()
            self:_remove(pItm)

            local pItm = m_rgpItems:get_last()
            local m_tpItVal = self.tpItVal

            self:_set_base_value(m_tpItVal[pItm])
        end
    end
end

function SRankedSet:list()
    local m_rgpItems = self.rgpItems
    return m_rgpItems:list()
end

function SRankedSet:dbg()
    local m_rgpItems = self.rgpItems

    local st = ""
    for k,v in pairs(m_rgpItems:list()) do
        st = st .. v .. ","
    end

    print("> " .. st)
end
