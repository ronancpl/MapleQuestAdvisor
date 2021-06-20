--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("utils.provider.io.file")
require("utils.provider.io.wordlist")
require("utils.provider.text.table")

function read_csv(sFilePath)
    local fn_split = split_csv
    return read_table(sFilePath, fn_split)
end

local function apply_unquoted(k)
    for w in k:gmatch("\"(%S+)\"") do
        return w
    end

    return k
end

local function get_header_indexes(rgsHeader)
    local tKeys = {}
    for k, v in ipairs(rgsHeader) do
        tKeys[apply_unquoted(v)] = k
    end

    return tKeys
end

local function filter_select_keys(rgsSelectKeys, rgsHeaderKeys)
    local rgsAppliedKeys = {}
    for _, v in ipairs(rgsSelectKeys) do
        if rgsHeaderKeys[v] ~= nil then
            table.insert(rgsAppliedKeys, v)
        end
    end

    return rgsAppliedKeys
end

function read_result_set(sFilePath, rgsSelectKeys)
    local rgRs = {}

    local rows_csv = read_csv(sFilePath)
    if #rows_csv > 1 then
        local tsKeys = get_header_indexes(rows_csv[1])
        rgsSelectKeys = filter_select_keys(rgsSelectKeys, tsKeys)

        for i = 2, #rows_csv, 1 do
            local pRow = rows_csv[i]

            local rgRsItem = {}
            for _, v in ipairs(rgsSelectKeys) do
                local iColIdx = tsKeys[v]
                local pValue = pRow[iColIdx]

                rgRsItem[v] = pValue
            end

            table.insert(rgRs, rgRsItem)
        end
    end

    return rgRs
end
