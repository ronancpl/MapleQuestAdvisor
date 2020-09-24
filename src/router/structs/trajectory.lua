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

CGraphTree = createClass(CQuestPath, {
    tpActiveNeighbors = {}
})

function CGraphTree:push_node(pQuestProp, tpNeighbors)
    self:add(pQuestProp)

    local tpNeighborsCopy = STable:new()
    tpNeighborsCopy:insert_table(tpNeighbors)
    self.tpActiveNeighbors[pQuestProp] = tpNeighborsCopy
end

function CGraphTree:_is_empty_on_erase_inactive_neighbors(tpNeighbors)
    local pToRemove = {}
    for i = 1, #tpNeighbors, 1 do
        local v = tpNeighbors[i]
        if not self:is_in_path(v) then
            table.insert(pToRemove, i)
        end
    end

    for i = #pToRemove, 1, -1 do
        table.remove(tpNeighbors, pToRemove[i])
    end

    return #tpNeighbors == 0
end

function CGraphTree:try_pop()
    local pQuestProp = self:get_last()

    local tpNeighbors = self.tpActiveNeighbors[pQuestProp]
    if tpNeighbors:is_empty() or self:_is_empty_on_erase_inactive_neighbors(tpNeighbors) then
        self:remove_last()
        return pQuestProp
    else
        return nil
    end
end
