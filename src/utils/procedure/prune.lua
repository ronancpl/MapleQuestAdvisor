--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("router.procedures.constant")
require("utils.procedure.copy")

local function fn_compare_rank(a, b)
    return a[2] > b[2]
end

local function table_rank(tTable, fn_rank, nMaxEntries, rgpAllowKeys)
    local tpAllowKeys = {}

    if rgpAllowKeys ~= nil then
        for _, k in ipairs(rgpAllowKeys) do
            tpAllowKeys[k] = 1
        end

        nAllowKeys = #rgpAllowKeys
    else
        nAllowKeys = 0
    end

    local rgpEntries = {}
    for k, v in pairs(tTable) do
        local iVal = tpAllowKeys[k] == nil and fn_rank(v) or U_INT_MAX
        table.insert(rgpEntries, {k, iVal})
    end
    table.sort(rgpEntries, fn_compare_rank)

    local rgpKeys = {}
    for i = 1, math.max(math.min(nMaxEntries or U_INT_MAX, #rgpEntries), nAllowKeys), 1 do
        table.insert(rgpKeys, rgpEntries[i][1])
    end
    return rgpKeys
end

local function table_cut(tTable, rgpKeys)
    return table_select(tTable, rgpKeys)
end

function table_prune(tTable, fn_rank, nMaxEntries, rgpAllowKeys)
    local rgpKeys = table_rank(tTable, fn_rank, nMaxEntries)
    local tPrune = table_cut(tTable, rgpKeys)
    return tPrune
end
