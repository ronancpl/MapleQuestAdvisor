--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

CQuestPath = createClass({
    tpPath = SArray:new(),
    tpPathSet = {},
    tsPathSet = {},
    iPathValue = 0.0
})

function CQuestPath:_fetch_identifier(iQuestid, bStart)
    return "" .. iQuestid .. (bStart and "s" or "e")
end

function CQuestPath:add(pQuestProp)
    local iQuestid = pQuestProp:get_quest_id()
    local bStart = pQuestProp:is_start()

    local sQuestState = self:_fetch_identifier(iQuestid, bStart)
    tsPathSet[sQuestState] = pQuestProp
    tpPathSet[pQuestProp] = pQuestProp
end

function CQuestPath:remove(pQuestProp)
    local sQuestState = self:_fetch_identifier(iQuestid, bStart)
    tsPathSet[sQuestState] = nil
    tpPathSet[pQuestProp] = nil
end

function CQuestPath:remove_by_quest_state(iQuestid, bStart)
    local sQuestState = self:_fetch_identifier(iQuestid, bStart)

    local pQuestProp = tsPathSet[sQuestState]
    if pQuestProp ~= nil then
        tsPathSet[sQuestState] = nil
        tpPathSet[pQuestProp] = nil
    end
end

function CQuestPath:is_empty()
    return self.tpPath:is_empty()
end

function CQuestPath:is_quest_state_in_path(iQuestid, bStart)
    local sQuestState = self:_fetch_identifier(iQuestid, bStart)
    return tsPathSet[sQuestState] ~= nil
end

function CQuestPath:is_in_path(pQuestProp)
    return tpPathSet[pQuestProp] ~= nil
end
