--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("utils.struct.class")
require("utils.struct.ranked_set")

CQuestLane = createClass({
    pSetPaths = SRankedSet:new(),
    tpSublanes = {}
})

function CQuestLane:set_capacity(iCap)
    local m_pSetPaths = self.pSetPaths
    m_pSetPaths:set_capacity(iCap)
end

function CQuestLane:pop_path()
    local m_pSetPaths = self.pSetPaths
    return m_pSetPaths:pop()
end

function CQuestLane:add_path(pPath, fVal)
    local m_pSetPaths = self.pSetPaths
    m_pSetPaths:insert(pPath, fVal)
end

function CQuestLane:get_paths()
    local m_pSetPaths = self.pSetPaths
    return m_pSetPaths:list()
end

function CQuestLane:add_sublane(pQuestProp, pLane)
    local m_tpSublanes = self.tpSublanes
    m_tpSublanes[pQuestProp] = pLane
end

function CQuestLane:get_sublane(pQuestProp)
    local m_tpSublanes = self.tpSublanes
    return m_tpSublanes[pQuestProp]
end

function CQuestLane:get_sublanes()
    local m_tpSublanes = self.tpSublanes

    local tpEntries = {}
    for pQuestProp, pLane in pairs(m_tpSublanes) do
        tpEntries[pQuestProp] = pLane
    end

    return tpEntries
end

function CQuestLane:sublanes_tostring(sPath, rgsLanePaths)
    local tpEntries = self:get_sublanes()
    if next(tpEntries) ~= nil then
        for pQuestProp, pSublane in pairs(tpEntries) do
            local sSubpath = sPath .. pQuestProp:get_name() .. ","
            pSublane:sublanes_tostring(sSubpath, rgsLanePaths)
        end
    else
        table.insert(rgsLanePaths, sPath)
    end
end

function CQuestLane:list_quest_paths()
    local rgsPaths = {}
    self:sublanes_tostring("", rgsPaths)

    return rgsPaths
end
