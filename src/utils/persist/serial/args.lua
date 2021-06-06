--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("utils.persist.serial.table")
require("utils.procedure.copy")
require("utils.procedure.string")

local function put_index_rdbms_args(rgpArgs)
    local tpTable = load_file_resultset("arrays.txt") or {}

    for i = 1, #rgpArgs, 1 do
        local pItem = rgpArgs[i]
        if type(pItem) == "table" then
            local sTableMeta = tostring(pItem)
            tpTable[sTableMeta] = pItem
        end
    end

    save_file_resultset("arrays.txt", tpTable)
end

local function take_index_rdbms_arg(tpArrays)
    local tpTable = load_file_resultset("arrays.txt") or {}

    local tpRdbmsArrs = {}

    for sTableMeta, iIdx in pairs(tpArrays) do
        local pItem = tpTable[sTableMeta]

        tpRdbmsArrs[iIdx] = pItem
        tpTable[sTableMeta] = nil
    end

    save_file_resultset("arrays.txt", tpTable)

    return tpRdbmsArrs
end

function serialize_rdbms_args(rgpRdbmsArgs)
    local sArgs = ""

    for i = 1, #rgpRdbmsArgs, 1 do
        local pItem = rgpRdbmsArgs[i]

        if pItem == nil then
            sArgs = sArgs .. "\"nil\" "
        else
            sArgs = sArgs .. "\"" .. tostring(pItem) .. "\" "
        end
    end

    put_index_rdbms_args(rgpRdbmsArgs)

    return sArgs
end

function unserialize_rdbms_args(rgpArgs)
    local rgpRdbmsArgs = {}

    local tpArrs = {}

    for i = 1, #rgpArgs, 1 do
        local pItem = rgpArgs[i]
        if pItem ~= nil and string.starts_with(pItem, "table: ") then
            rgpRdbmsArgs[i] = nil
            tpArrs[pItem] = i
        else
            rgpRdbmsArgs[i] = pItem
        end
    end

    local tpRdbmsArrs = take_index_rdbms_arg(tpArrs)
    table_merge(rgpRdbmsArgs, tpRdbmsArrs)

    return rgpRdbmsArgs
end
