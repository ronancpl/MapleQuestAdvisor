--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

function rpairs(tTable)   -- in reverse order
    local rgpItems = {}
    for i = #tTable, 1, -1 do
        local pItem = tTable[i]
        table.insert(rgpItems, pItem)
    end

    return ipairs(rgpItems)
end

function cpairs(tTable, iFromIdx, iToIdx)   -- in range (slice) order
    local rgpItems = {}
    for i = iFromIdx, math.min(iToIdx, #tTable), 1 do
        local pItem = tTable[i]
        table.insert(rgpItems, pItem)
    end

    return ipairs(rgpItems)
end
