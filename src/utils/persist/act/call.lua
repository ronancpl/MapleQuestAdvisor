--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("router.constants.path")
require("utils.persist.interface.routines")
require("utils.persist.serial.args")
require("utils.provider.io.wordlist")

function db_pk_table(sTableCols)
    local rgsCols = split_csv(sTableCols)
    return rgsCols[1]
end

local function db_insert_table_cols(tpTableCols, sTableName, sCols)
    local rgsCols = split_csv(sCols)

    local tpCols = {}
    for iId, sName in ipairs(rgsCols) do
        tpCols[sName] = iId
    end
    tpCols['_'] = sCols

    tpTableCols[sTableName] = tpCols
end

function load_db_table_cols()
    local tpTableCols = {}

    db_insert_table_cols(tpTableCols, RPersistPath.RATES, RPersistTable.RATES)
    db_insert_table_cols(tpTableCols, RPersistPath.STAT, RPersistTable.STAT)
    db_insert_table_cols(tpTableCols, RPersistPath.INVENTORY, RPersistTable.INVENTORY)

    return tpTableCols
end

function find_rdbms_col(tpTableCols, sTableName, sColName)
    local i = -1

    local tpCols = tpTableCols[sTableName]
    if tpCols ~= nil then
        i = tpCols[sColName] or -1
    end

    return i
end

local function open_rdbms_script(...)
    local sCmdRdbms = "lua5.1 utils/persist/act/fetch.lua"

    local sArgs = serialize_rdbms_args(...)
    local pHdl = os.execute(sCmdRdbms .. " " .. sArgs)

    return pHdl
end

local function collect_rdbms_result()
    local pRes = dofile("utils/persist/act/collect.lua")
    return pRes
end

function db_new(sDataSource)
    open_rdbms_script({RSqlFunction.NEW, sDataSource})

    local pRes = collect_rdbms_result()
    return pRes
end

function db_kv_add(pCon, sTable, pKey, rgpVals)
    local pHdl = open_rdbms_script({RSqlFunction.ADD, nil, sTable, pKey, rgpVals})

    local pRes = collect_rdbms_result()
    return pRes
end

function db_kv_fetch(pCon, sTable, pKey, pVal)
    local pHdl = open_rdbms_script({RSqlFunction.FETCH, nil, sTable, pKey, pVal})     -- interface has connection assigned

    local pRes = collect_rdbms_result()
    return pRes
end

function db_kv_delete(pCon, sTable, pKey, pVal)
    local pHdl = open_rdbms_script({RSqlFunction.DELETE, nil, sTable, pKey, pVal})

    local pRes = collect_rdbms_result()
    return pRes
end

function db_close(pCon)
    local pHdl = open_rdbms_script({RSqlFunction.CLOSE, nil})

    local pRes = collect_rdbms_result()
    return pRes
end
