--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

function spairs(tTable, fn_table_sort)
    local rgKeys = {}
    for k, _ in pairs(tTable) do
        table.insert(rgKeys, k)
    end

    table.sort(rgKeys, fn_table_sort)

    local rgpPairs = {}
    for _, k in pairs(rgKeys) do
        local pPair = {k, tTable[k]}
        table.insert(rgpPairs, pPair)
    end

    return rgpPairs
end
