--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("structs.quest.properties")
require("router.structs.path")
require("utils.struct.table")

CGraphTree = createClass({CQuestPath, {
    tpActiveNeighbors = {},
    tpActiveFroms = {},
    tiResolvedFroms = {}
}})

function CGraphTree:_push_from(pQuestProp, rgpNeighbors)
    local m_tpActiveFroms = self.tpActiveFroms

    for _, pNeighborProp in ipairs(rgpNeighbors) do
        local pNeighborFroms = m_tpActiveFroms[pNeighborProp]
        if pNeighborFroms == nil then
            pNeighborFroms = {}
            m_tpActiveFroms[pNeighborProp] = pNeighborFroms
        end

        table.insert(pNeighborFroms, pQuestProp)
    end
end

function CGraphTree:_push_neighbors(pQuestProp, rgpNeighbors)
    local rgpNeighborsCopy = SArray:new()
    rgpNeighborsCopy:add_all(rgpNeighbors)

    self.tpActiveNeighbors[pQuestProp] = rgpNeighborsCopy
end

function CGraphTree:push_node(pQuestProp, rgpNeighbors)
    self:add(pQuestProp)

    self:_push_neighbors(pQuestProp, rgpNeighbors)
    self:_push_from(pQuestProp, rgpNeighbors)
end

function CGraphTree:_is_empty_active_neighbors(pQuestProp)
    local rgpNeighbors = self.tpActiveNeighbors[pQuestProp]
    return rgpNeighbors:size() == 0
end

function CGraphTree:_pop_from(pQuestProp)
    local m_tpActiveFroms = self.tpActiveFroms
    local m_tiResolvedFroms = self.tiResolvedFroms

    local rgpFroms = m_tpActiveFroms[pQuestProp]
    if rgpFroms ~= nil then
        local m_tpActiveNeighbors = self.tpActiveNeighbors

        for _, pFromProp in ipairs(rgpFroms) do
            local rgFromActiveNeighbors = m_tpActiveNeighbors[pFromProp]

            local fn_compare_active_neighbor = CQuestProperties.compare
            local iIdx = rgFromActiveNeighbors:bsearch(fn_compare_active_neighbor, pQuestProp, false, true)
            if iIdx > 0 then
                rgFromActiveNeighbors:remove(iIdx, iIdx)
            end
        end

        m_tpActiveNeighbors[pQuestProp] = nil
        m_tpActiveFroms[pQuestProp] = nil

        m_tiResolvedFroms[pQuestProp] = #rgpFroms
    else
        m_tiResolvedFroms[pQuestProp] = 1
    end
end

function CGraphTree:get_from_count(pQuestProp)
    local m_tiResolvedFroms = self.tiResolvedFroms
    return m_tiResolvedFroms[pQuestProp]
end

function CGraphTree:try_pop_node()
    local m_rgpPath = self.rgpPath
    local pQuestProp = m_rgpPath:get_last()

    if self:_is_empty_active_neighbors(pQuestProp) then
        m_rgpPath:remove_last()
        self:_pop_from(pQuestProp)

        return pQuestProp
    else
        return nil
    end
end

function CGraphTree:debug_tree()
    print(" --- CURRENT TREE PATH ---")

    local l = self.rgpPath:list()
    for i = math.max(1, #l - 5), #l, 1 do
        local s = ""
        local pQuestProp = l[i]

        local s = pQuestProp:get_name(true) .. " -> ["
        for _, v in pairs(self.tpActiveNeighbors[pQuestProp]:list()) do
            s = s .. v:get_name(true) .. ", "
        end
        s = s .. "]"

        print(s)
    end

    print()
end
