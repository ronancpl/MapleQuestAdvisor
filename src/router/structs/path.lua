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

CQuestPath = createClass({
    rgpPath = SArray:new(),
    tpSetPath = {},
    tsSetPath = {},
    tpPathCount = {},

    pPathTree = {},
    pPathNow = {},
    pPathStack = {},

    pPathValStack = {},
    fPathValue = 0.0,

    sFetchTime = os.date("%H-%M-%S")
})

function CQuestPath:_fetch_identifier(iQuestid, bStart)
    return "" .. iQuestid .. (bStart and "s" or "e")
end

function CQuestPath:add(pQuestProp, fValue)
    local iPathCount = self.tpPathCount[pQuestProp] or 0
    if iPathCount < 1 then
        local iQuestid = pQuestProp:get_quest_id()
        local bStart = pQuestProp:is_start()

        local sQuestState = self:_fetch_identifier(iQuestid, bStart)
        self.tsSetPath[sQuestState] = pQuestProp
        self.tpSetPath[pQuestProp] = pQuestProp
    end

    self.rgpPath:add(pQuestProp)
    self.tpPathCount[pQuestProp] = iPathCount + 1
    self.pPathNow[pQuestProp] = {}
    table.insert(self.pPathStack, self.pPathNow)
    self.pPathNow = self.pPathNow[pQuestProp]

    table.insert(self.pPathValStack, fValue)
    self.fPathValue = self.fPathValue + fValue
end

function CQuestPath:remove(pQuestProp)
    local bRet = false

    local iPathCount = self.tpPathCount[pQuestProp]
    if iPathCount ~= nil then
        if iPathCount < 2 then
            local sQuestState = self:_fetch_identifier(pQuestProp:get_quest_id(), pQuestProp:is_start())
            self.tsSetPath[sQuestState] = nil
            self.tpSetPath[pQuestProp] = nil
            self.tpPathCount[pQuestProp] = nil
        else
            self.tpPathCount[pQuestProp] = iPathCount - 1
        end

        local fn_select = function(pOtherProp)
            return pOtherProp == pQuestProp
        end

        local m_rgpPath = self.rgpPath
        local iIdx = m_rgpPath:index_of(fn_select, false)
        m_rgpPath:remove(iIdx, iIdx)

        bRet = true

        self.pPathNow = table.remove(self.pPathStack)
        local fValue = table.remove(self.pPathValStack)
        self.fPathValue = self.fPathValue - fValue
    end

    return bRet
end

function CQuestPath:remove_by_quest_state(iQuestid, bStart)
    local sQuestState = self:_fetch_identifier(iQuestid, bStart)

    local pQuestProp = self.tsSetPath[sQuestState]
    if pQuestProp ~= nil then
        return self:remove(pQuestProp)
    end

    return false
end

function CQuestPath:is_empty()
    return self.rgpPath:is_empty()
end

function CQuestPath:is_quest_state_in_path(iQuestid, bStart)
    local sQuestState = self:_fetch_identifier(iQuestid, bStart)
    return self.tsSetPath[sQuestState] ~= nil
end

function CQuestPath:is_in_path(pQuestProp)
    return self.tpSetPath[pQuestProp] ~= nil
end

function CQuestPath:list()
    return self.rgpPath:list()
end

function CQuestPath:size()
    return #(self.pPathStack)
end

function CQuestPath:get_node_value(iIdx)
    local m_pPathValStack = self.pPathValStack
    return m_pPathValStack[iIdx]
end

function CQuestPath:value()
    return self.fPathValue
end

function CQuestPath:set(pOtherPath)
    local rgpOtherQuests = pOtherPath:list()
    local rgpQuests = self:list()

    local nMaxQuests = math.min(#rgpQuests, #rgpOtherQuests)

    local i = 1
    while i < nMaxQuests and rgpQuests[i] == rgpOtherQuests[i] do
        i = i + 1
    end

    local iBaseIdx = i
    for i = #rgpQuests, iBaseIdx, -1 do
        local pQuestProp = rgpQuests[i]
        self:remove(pQuestProp)
    end

    for i = iBaseIdx, #rgpOtherQuests, 1 do
        local pQuestProp = rgpOtherQuests[i]
        local fValue = pOtherPath:get_node_value(i)

        self:add(pQuestProp, fValue)
    end
end

function CQuestPath:get_fetch_time()
    return self.sFetchTime
end

function CQuestPath:debug_path()
    local st = "["
    for _, pQuestProp in pairs(self.rgpPath:list()) do
        st = st .. pQuestProp:get_name(true) .. ", "
    end
    st = st .. "]"

    print(st)
end
