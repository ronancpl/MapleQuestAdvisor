--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("router.constants.timer")
require("utils.procedure.unpack")
require("utils.struct.class")

SMapTimed = createClass({
    tpShortUpd = {},
    tpLongUpd = {},
    bClosed = false
})

function SMapTimed:is_closed()
    return self.bClosed
end

function SMapTimed:close()
    self.bClosed = true
end

local function update_table_short(tpTimed)
    if tpTimed:is_closed() then
        return
    end

    tpTimed:update_short()
    timer.performWithDelay(RTimer.UPDT_SHORT, update_table_short)
end

local function update_table_long(tpTimed)
    if tpTimed:is_closed() then
        return
    end

    tpTimed:update_long()
    timer.performWithDelay(RTimer.UPDT_LONG, update_table_long)
end

function SMapTimed:init()
    self.bClosed = false

    update_table_short(self)
    update_table_long(self)
end

function SMapTimed:_move_insert(pKey, pTmVal)
    local m_tpShortUpd = self.tpShortUpd
    local m_tpLongUpd = self.tpLongUpd

    m_tpShortUpd[pKey] = pTmVal
    m_tpLongUpd[pKey] = nil
end

function SMapTimed:insert(pKey, pVal, liTimeout)
    local m_tpLongUpd = self.tpLongUpd
    m_tpLongUpd[pKey] = {os.clock(), liTimeout, pVal}
end

function SMapTimed:remove(pKey)
    self.tpShortUpd[pKey] = nil
    self.tpLongUpd[pKey] = nil
end

function SMapTimed:update_short()
    local t = os.clock()

    local m_tpShortUpd = self.tpShortUpd

    local rgpToRmv = {}
    for pKey, pTmVal in pairs(m_tpShortUpd) do
        local te = pTmVal[2]

        local tElapsed = t - pTmVal[1]
        if tElapsed > te then
            table.insert(rgpToRmv, pKey)
        end
    end

    for _, pKey in pairs(rgpToRmv) do
        m_tpShortUpd[pKey] = nil
    end
end

function SMapTimed:update_long()
    local t = os.clock()
    local tpToMv = {}

    local m_tpShortUpd = self.tpShortUpd
    for pKey, pTmVal in pairs(m_tpShortUpd) do
        local te = pTmVal[2]

        local tElapsed = t - pTmVal[1]
        if tElapsed > te then
            tpToMv[pKey] = pTmVal
        end
    end

    for pKey, pTmVal in pairs(tpToMv) do
        self:_move_insert(pKey, pTmVal)
    end
end

function SMapTimed:reset()
    clear_table(self.tpShortUpd)
    clear_table(self.tpLongUpd)
end
