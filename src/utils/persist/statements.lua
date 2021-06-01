--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("utils.struct.class")

CPreparedStorage = createClass({
    tpSlctClauses = {},
    tpCreateClauses = {}
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
end

local function make_sq3_create_stmt(nCols)
    local sParams = fetch_sq3_params_clause(nCols)

    local pStmt = sqlite3.prepare("CREATE TABLE ? (" .. sParams .. ")")
    return pStmt
end

local function make_sq3_insert_stmt(nCols)
    local sParams = fetch_sq3_params_clause(nCols)

    local pStmt = sqlite3.prepare("INSERT INTO ? VALUES (" .. sParams .. ")")
    return pStmt
end

local function make_sq3_update_stmt(sSelectSql, nBinds)
    local pStmt = sqlite3.prepare(sSelectSql or "UPDATE ? SET ?=?"), 3 or nBinds
    return pStmt, nBinds
end

local function make_sq3_delete_stmt(sSelectSql, nBinds)
    local pStmt = sqlite3.prepare(sSelectSql or "DELETE FROM ? WHERE ?=?", 3) or nBinds
    return pStmt, nBinds
end

local function make_sq3_select_stmt(sSelectSql, nBinds)
    return sqlite3.prepare(sSelectSql or "SELECT * FROM ?"), 1 or nBinds
end

local function fetch_stmt(nCols, m_tpClauses, fn_make_stmt)
    local pStmt = m_tpClauses[nCols]
    if pStmt ~= nil then
        pStmt = fn_make_stmt(nCols)
        m_tpClauses[nCols] = pStmt
    end

    return pStmt
end

local function compose_fetch_stmt(nCols, m_tpClauses, fn_make_stmt, sSelectSql)
    local pStmt = m_tpClauses[nCols]
    if pStmt ~= nil then
        pStmt = fn_make_stmt(sSelectSql, nCols)
        m_tpClauses[nCols] = pStmt
    end

    return pStmt
end

function CPreparedStorage:get_create_stmt(nCols)
    local m_tpClauses = self.tpCreateClauses
    local fn_make_stmt = make_sq3_create_stmt

    return fetch_stmt(nCols, m_tpClauses, fn_make_stmt)
end

function CPreparedStorage:get_insert_stmt(nCols)
    local m_tpClauses = self.tpSlctClauses
    local fn_make_stmt = make_sq3_insert_stmt

    return fetch_stmt(nCols, m_tpClauses, fn_make_stmt)
end

function CPreparedStorage:get_update_stmt(nBinds, sSelectSql)
    local m_tpClauses = self.tpCreateClauses
    local fn_make_stmt = make_sq3_update_stmt

    return compose_fetch_stmt(nBinds, m_tpClauses, fn_make_stmt, sSelectSql)
end

function CPreparedStorage:get_delete_stmt(nBinds, sSelectSql)
    local m_tpClauses = self.tpCreateClauses
    local fn_make_stmt = make_sq3_delete_stmt

    return compose_fetch_stmt(nBinds, m_tpClauses, fn_make_stmt, sSelectSql)
end

function CPreparedStorage:get_select_stmt(nBinds, sSelectSql)
    local m_tpClauses = self.tpCreateClauses
    local fn_make_stmt = make_sq3_select_stmt

    return compose_fetch_stmt(nBinds, m_tpClauses, fn_make_stmt, sSelectSql)
end
