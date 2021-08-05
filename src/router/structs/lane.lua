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

function CQuestLane:get_capacity()
    local m_pSetPaths = self.pSetPaths
    return m_pSetPaths:get_capacity()
end

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

function CQuestLane:get_path_by_quest(pNextQuestProp)
    for _, pPath in ipairs(self:get_paths()) do
        local pQuestProp = pPath:list()[1]
        if pQuestProp == pNextQuestProp then
            return pPath
        end
    end

    return nil
end

function CQuestLane:_recommend_eval_path(tQuestProps, rgpRecommendedPaths, pPath)
    local rgpQuestProps = pPath:list()
    local pQuestProp = rgpQuestProps[1]
    if tQuestProps[pQuestProp] == nil then
        tQuestProps[pQuestProp] = 1
        table.insert(rgpRecommendedPaths, pPath)
    end
end

function CQuestLane:get_recommended_paths()
    local rgpPaths = self:get_paths()
    table.sort(rgpPaths, function (a, b) return a:value() < b:value() end)

    local tQuestProps = {}
    local rgpRecommendedPaths = {}
    for _, pPath in ipairs(rgpPaths) do
        self:_recommend_eval_path(tQuestProps, rgpRecommendedPaths, pPath)
    end

    return rgpRecommendedPaths
end

function CQuestLane:get_path_entries()
    local m_pSetPaths = self.pSetPaths
    return m_pSetPaths:get_entry_set()
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

function CQuestLane:merge_lane(pOtherLane)
    self:set_capacity(pOtherLane:get_capacity())

    for pPath, fVal in pairs(self:get_path_entries()) do
        self:add_path(pPath, fVal)
    end

    for pQuestProp, pLane in pairs(pOtherLane:get_sublanes()) do
        local pLaneCopy = CQuestLane:new()
        pLaneCopy:merge_lane(pLane)

        self:add_sublane(pQuestProp, pLaneCopy)
    end
end

function CQuestLane:to_string()
    local st = "{"
    for pQuestProp, _ in pairs(self:get_sublanes()) do
        st = st .. pQuestProp:get_name() .. ", "
    end
    st = st .. "}"

    return st
end
