--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

CApTableSequence = createClass(CApTableElement, {
    iAgentid,
    iIdx
})

function CApTableSequence:get_index()
    return self.iIdx
end

function CApTableSequence:set_index(iIdx)
    self.iIdx = iIdx
end

function CApTableSequence:get_agent_id()
    return self.iAgentid
end
