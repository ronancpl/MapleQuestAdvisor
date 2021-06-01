--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("utils.persist.statements")

local sqlite3 = require("sqlite3")
local pStorageStmt = CPreparedStorage:new()

function sq3_new(sDataSource)
    local pCon = sqlite3.open(sDataSource)
    return pCon
end

function sq3_kv_add(pCon, sTable, sColName, pKey, pVal)
    local pStmt = pStorageStmt:get_insert_stmt(2)
    pStmt:bind_values({sColName, pKey, pVal})

    local pRes = pCon:exec(pStmt)
    if pRes ~= sqlite3.OK then
        pStmt = pStorageStmt:get_update_stmt(1)
        pStmt:bind_values({sTable, sColName, pKey})

        local pRes = pCon:exec(pStmt)
        assert(pRes ~= sqlite3.OK)

        return nil, pRes
    else
        local iId = db:last_insert_rowid()
        return iId, pRes
    end
end

function sq3_kv_delete(pCon, sTable, sColName, pKey)
    local pStmt = pStorageStmt:get_delete_stmt(1)
    pStmt:bind_values({sTable, sColName, pKey})

    local pRes = pCon:exec(pStmt)
    return pRes
end

function sq3_kv_fetch(pCon, sTable, sColName, pKey)
    local pStmt = pStorageStmt:get_select_stmt(3, "SELECT * FROM ? WHERE ?=?")
    pStmt:bind_values({sTable, sColName, pKey})

    local pRes = pCon:exec()
    return pRes
end

function sq3_kv_fetch_all(pCon, sTable)
    local pStmt = pStorageStmt:get_select_stmt(1)
    pStmt:bind_values({sTable})

    pCon:exec(pStmt)

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
    pCon:close()
end
