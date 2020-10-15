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
    tpPathSet = {},
    tsPathSet = {},
    tpPathCount = {},
    iPathValue = 0.0
})

function CQuestPath:_fetch_identifier(iQuestid, bStart)
    return "" .. iQuestid .. (bStart and "s" or "e")
end

function CQuestPath:add(pQuestProp)
    local iPathCount = self.tpPathCount[pQuestProp] or 0
    if iPathCount < 1 then
        local iQuestid = pQuestProp:get_quest_id()
        local bStart = pQuestProp:is_start()

        local sQuestState = self:_fetch_identifier(iQuestid, bStart)
        self.tsPathSet[sQuestState] = pQuestProp
        self.tpPathSet[pQuestProp] = pQuestProp
    end

    self.rgpPath:add(pQuestProp)
    self.tpPathCount[pQuestProp] = iPathCount + 1
end

function CQuestPath:remove(pQuestProp)
    local bRet = false

    local iPathCount = self.tpPathCount[pQuestProp]
    if iPathCount ~= nil then
        if iPathCount < 2 then
            local sQuestState = self:_fetch_identifier(pQuestProp:get_quest_id(), pQuestProp:is_start())
            self.tsPathSet[sQuestState] = nil
            self.tpPathSet[pQuestProp] = nil
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
    end

    return bRet
end

function CQuestPath:remove_by_quest_state(iQuestid, bStart)
    local sQuestState = self:_fetch_identifier(iQuestid, bStart)

    local pQuestProp = tsPathSet[sQuestState]
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
    return self.tsPathSet[sQuestState] ~= nil
end

function CQuestPath:is_in_path(pQuestProp)
    return self.tpPathSet[pQuestProp] ~= nil
end

function CQuestPath:list()
    return self.rgpPath:list()
end

local function fn_value_start_property(pQuestProp)
    return pQuestProp:is_start() and 0 or 1
end
