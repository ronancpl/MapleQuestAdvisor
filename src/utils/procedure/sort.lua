--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

local function is_array(m_apItems)
    local bRet = true
    if next(m_apItems) ~= nil then
        bRet = (m_apItems[1] ~= nil)
    end

    return bRet
end

local function fetch_array_values(m_apItems)
    local tTable = {}
    for iKey, pVal in ipairs(m_apItems) do
        tTable[pVal] = iKey
    end

    return tTable
end

function spairs_table(m_apItems)
    local bArray = is_array(m_apItems)
    local tTable = bArray and fetch_array_values(m_apItems) or m_apItems

    return tTable, bArray
end

function spairs(tTable, fn_table_sort)
    local rgpPairs = {}

    local rgKeys = {}
    if next(tTable) ~= nil then
        for k, _ in pairs(tTable) do
            table.insert(rgKeys, k)
        end

        table.sort(rgKeys, fn_table_sort)

        for _, k in pairs(rgKeys) do
            local pPair = {k, tTable[k]}
            table.insert(rgpPairs, pPair)
        end
    end

    return rgpPairs
end
