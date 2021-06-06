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

function sq3_kv_add(pCon, sTable, rgpVals, pKey)
    pCon = make_connection(pRdbms:get_rdbms_ds())     -- no actual connection through API
    local pStorageStmt = pRdbms:get_storage_statements()

    local pStmt = pStorageStmt:get_insert_stmt(pCon, #rgpVals, sTable)

    pCon:exec('begin')

    pStmt:bind_values(unpack(rgpVals))     -- pVal : insert tuple
    pStmt:step()
    pStmt:reset()

    --pStmt:finalize()      -- Reusing statement

    local pRes = pCon:exec('commit')

    if pRes ~= sqlite3.OK then
        local iIdx = find_rdbms_col(sTable, pKey)
        pStmt = pStorageStmt:get_update_stmt(pCon, 0, sTable, pKey, pVal[iIdx] or "")

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
    pCon = make_connection(pRdbms:get_rdbms_ds())

    local pStorageStmt = pRdbms:get_storage_statements()
    local pStmt = pStorageStmt:get_select_stmt(pCon, 0, nil, sTable, sColName, pVal)

    local pRes = execute_prep_statement(pCon, pStmt)
    return pRes
end

function sq3_kv_fetch_all(pCon, sTable)
    pCon = make_connection(pRdbms:get_rdbms_ds())

    local pStorageStmt = pRdbms:get_storage_statements()
    local pStmt = pStorageStmt:get_select_stmt(pCon, 0, nil, sTable)

    execute_prep_statement(pCon, pStmt)

    local tpItems = {}

    local pNext
    while pNext ~= sqlite3.DONE do
        pNext = pStmt:step()

        if pNext ~= sqlite3.ROW then
            log(LPath.DB, "Error " .. tostring(pNext) .. " trying to parse query with '" .. sTable .. "', have result-set: [" .. tostring(pStmt:get_named_types()) .. "]")
            pNext = sqlite3.DONE
        else
            tpItems[pStmt:get_value(0)] = pStmt:get_values()
        end
    end

    return tpItems
end

function sq3_close(pCon)
    if true then return end     -- no actual connection through API
    pCon:close()
end
