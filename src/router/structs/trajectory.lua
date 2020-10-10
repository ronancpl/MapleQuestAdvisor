--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("router.structs.path")
require("utils.table")

CGraphTree = createClass({CQuestPath, {
    tpActiveNeighbors = {}
}})

function CGraphTree:push_node(pQuestProp, rgpNeighbors)
    self:add(pQuestProp)

    local rgpNeighborsCopy = STable:new()
    rgpNeighborsCopy:insert_table(rgpNeighbors)
    self.tpActiveNeighbors[pQuestProp] = rgpNeighborsCopy
end

function CGraphTree:_is_empty_on_erase_inactive_neighbors(rgpNeighbors)
    local tiToRemove = {}
    for i = 1, #rgpNeighbors, 1 do
        local v = rgpNeighbors[i]
        if not self:is_in_path(v) then
            table.insert(tiToRemove, i)
        end
    end

    for i = #tiToRemove, 1, -1 do
        table.remove(rgpNeighbors, tiToRemove[i])
    end

    return #rgpNeighbors == 0
end

function CGraphTree:try_pop_node()
    local m_rgpPath = self.rgpPath
    local pQuestProp = m_rgpPath:get_last()

    local rgpNeighbors = self.tpActiveNeighbors[pQuestProp]
    if rgpNeighbors:is_empty() or self:_is_empty_on_erase_inactive_neighbors(rgpNeighbors) then
        m_rgpPath:remove_last()
        return pQuestProp
    else
        return nil
    end
end
