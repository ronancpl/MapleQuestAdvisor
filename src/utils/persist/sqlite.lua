--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

local sqlite3 = require('lsqlite3complete')

local function make_connection(sDataSource)
    local pCon = sqlite3.open(sDataSource)
    return pCon
end

function sq3_setup(sDataSource, tpTableCols)
    os.remove(sDataSource)

    local pCon = sqlite3.open(sDataSource)
    for sTableName, tpCols in pairs(tpTableCols) do
        local sCols = tpCols['_']
        pCon:exec('CREATE TABLE "' .. sTableName .. '"(' .. sCols .. ')')
    end
end

function sq3_new(sDataSource)
    local pCon = make_connection(sDataSource)
    return tostring(pCon)
end

local function execute_prep_statement(pCon, pStmt)
    pCon:exec('begin')

    pStmt:step()
    --pStmt:finalize()      -- Reusing statement

    local pRes = pCon:exec('commit')
    return pRes
end

local function execute_prep_query(pCon, pStmt)
    pCon:exec('begin')

    local rgpRows = {}

    local pStep = pStmt:step()
    while (pStep == sqlite3.ROW) do
        local rgpVals = pStmt:get_values()
        table.insert(rgpRows, rgpVals)

        pStep = pStmt:step()
    end

    --pStmt:finalize()      -- Reusing statement
    return rgpRows
end

function sq3_kv_add(pCon, sTable, rgpVals, pKey)
    pCon = make_connection(pRdbms:get_rdbms_ds())     -- no actual connection through API
    local pStorageStmt = pRdbms:get_storage_statements()

    local pStmt = pStorageStmt:get_insert_stmt(pCon, #rgpVals, sTable)

    pCon:exec('begin')

    pStmt:bind_values(unpack(rgpVals))     -- rgpVals : insert tuple
    pStmt:step()
    pStmt:reset()

    --pStmt:finalize()      -- Reusing statement

    local pRes = pCon:exec('commit')
    if pRes ~= sqlite3.OK then
        local iIdx = find_rdbms_col(sTable, pKey)
        pStmt = pStorageStmt:get_update_stmt(pCon, 0, sTable, pKey, rgpVals[iIdx] or "")

        local pRes = execute_prep_statement(pCon, pStmt)
        assert(pRes ~= sqlite3.OK)

        return nil, pRes
    else
        local iId = pCon:last_insert_rowid()
        return iId, pRes
    end
end

function sq3_kv_delete(pCon, sTable, sColName, pVal)
    pCon = make_connection(pRdbms:get_rdbms_ds())

    local pStorageStmt = pRdbms:get_storage_statements()
    local pStmt = pStorageStmt:get_delete_stmt(pCon, 0, sTable, sColName, pVal)

    local pRes = execute_prep_statement(pCon, pStmt)
    return pRes
end

function sq3_kv_fetch(pCon, sTable, sColName, pVal)
    log_st(LPath.DB, "_vf_fetch.txt", " >> " .. tostring(sTable) .. " | " .. tostring(sColName) .. " " .. tostring(pVal))
    pCon = make_connection(pRdbms:get_rdbms_ds())

    local pStorageStmt = pRdbms:get_storage_statements()
    local pStmt = pStorageStmt:get_select_stmt(pCon, 0, nil, sTable, sColName, pVal)

    local rgpRows = execute_prep_query(pCon, pStmt)
    if next(rgpRows) ~= nil then
        return rgpRows[1]
    else
        return nil
    end
end

function sq3_kv_fetch_all(pCon, sTable)
    pCon = make_connection(pRdbms:get_rdbms_ds())

    local pStorageStmt = pRdbms:get_storage_statements()
    local pStmt = pStorageStmt:get_select_stmt(pCon, 0, nil, sTable)

    local rgpRows = execute_prep_query(pCon, pStmt)
    return rgpRows
end

function sq3_close(pCon)
    if true then return end     -- no actual connection through API
    pCon:close()
end
