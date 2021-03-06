--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("router.constants.persistence")
require("utils.procedure.unpack")
require("utils.struct.class")

CPreparedStorage = createClass({
    tpCreateClauses = {},
    tpInstClauses = {},
    tpSlctClauses = {},
    tpUpdtClauses = {},
    tpDltClauses = {}
})

local function fetch_sq3_params_clause(nCols)
    local sSqlOpts = ""

    if nCols > 0 then
        if nCols > 1 then
            for i = 2, nCols, 1 do
                sSqlOpts = sSqlOpts .. "?,"
            end
        end

        sSqlOpts = sSqlOpts .. "?"
    end

    return sSqlOpts
end

local function make_sq3_create_stmt(pCon, sParams, sTableName)
    local pStmt = pCon:prepare("create table " .. sTableName .. "(" .. sParams .. ")")
    return pStmt
end

local function make_sq3_insert_stmt(pCon, nCols, sTableName)
    local sParams = fetch_sq3_params_clause(nCols)

    local pStmt = pCon:prepare("insert into " .. sTableName .. " values(" .. sParams .. ")")
    return pStmt
end

local function make_sq3_update_stmt(pCon, sQuerySql, sTableName, sKey, sValue)
    local sKey, sValue = unpack(pKeyVal)

    local pStmt = pCon:prepare(sQuerySql or "update " .. sTableName .. " set " .. sKey .. "=" .. tostring(sValue))
    return pStmt
end

local function make_sq3_delete_stmt(pCon, sQuerySql, sTableName, sKey, sValue)
    local pStmt = pCon:prepare(sQuerySql or "delete from " .. sTableName .. " where " .. sKey .. "=" .. tostring(sValue))
    return pStmt
end

local function make_sq3_select_stmt(pCon, sQuerySql, sTableName, sKey, sValue)
    local sqlite3 = require('lsqlite3complete')
    pCon = sqlite3.open(RPersistPath.DB)

    if sKey == nil then
        local pStmt = pCon:prepare(sQuerySql or ("select * from '" .. sTableName .. "'"))
        return pStmt
    else
        local pStmt = pCon:prepare(sQuerySql or ("select * from '" .. sTableName .. "' where " .. sKey .. "=" .. tostring(sValue)))
        return pStmt
    end
end

local function fetch_stmt(pCon, nCols, sParams, m_tpClauses, fn_make_stmt, sTable)
    local pStmt = m_tpClauses[sTable]
    if pStmt == nil then
        pStmt = fn_make_stmt(pCon, sParams, sTable)
        m_tpClauses[sTable] = pStmt
    end

    return pStmt
end

local function compose_fetch_stmt(pCon, nCols, m_tpClauses, fn_make_stmt, sStmtSql, sTable, sKey, sValue)
    local pStmt = m_tpClauses[sTable]
    if pStmt == nil then
        pStmt = fn_make_stmt(pCon, sStmtSql, sTable, sKey, sValue)
        m_tpClauses[sTable] = pStmt
    end

    return pStmt
end

function CPreparedStorage:get_create_stmt(pCon, sParams, sTableName)
    local m_tpClauses = self.tpCreateClauses
    local fn_make_stmt = make_sq3_create_stmt

    return fetch_stmt(pCon, 0, sParams, m_tpClauses, fn_make_stmt, sTableName)
end

function CPreparedStorage:get_insert_stmt(pCon, nCols, sTableName)
    local m_tpClauses = self.tpInstClauses
    local fn_make_stmt = make_sq3_insert_stmt

    return fetch_stmt(pCon, nCols, nCols, m_tpClauses, fn_make_stmt, sTableName)
end

function CPreparedStorage:get_update_stmt(pCon, nBinds, sStmtSql, sTableName, sKey, sValue)
    local m_tpClauses = self.tpUpdtClauses
    local fn_make_stmt = make_sq3_update_stmt

    return compose_fetch_stmt(pCon, nBinds, m_tpClauses, fn_make_stmt, sStmtSql, sTableName, sKey, sValue)
end

function CPreparedStorage:get_delete_stmt(pCon, nBinds, sStmtSql, sTableName, sKey, sValue)
    local m_tpClauses = self.tpDltClauses
    local fn_make_stmt = make_sq3_delete_stmt

    return compose_fetch_stmt(pCon, nBinds, m_tpClauses, fn_make_stmt, sStmtSql, sTableName, sKey, sValue)
end

function CPreparedStorage:get_select_stmt(pCon, nBinds, sStmtSql, sTableName, sKey, sValue)
    local m_tpClauses = self.tpSlctClauses
    local fn_make_stmt = make_sq3_select_stmt

    return compose_fetch_stmt(pCon, nBinds, m_tpClauses, fn_make_stmt, sStmtSql, sTableName, sKey, sValue)
end

local function finalize_clauses(tpClause)
    for _, pStmt in pairs(tpClause) do
        pStmt:finalize()
    end
end

function CPreparedStorage:reset()
    local rgpClauses = {self.tpCreateClauses, self.tpInstClauses, self.tpSlctClauses, self.tpUpdtClauses, self.tpDltClauses}
    for _, tpClauses in ipairs(rgpClauses) do
        finalize_clauses(tpClauses)
    end
end
