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
require("utils.persist.serial.table")
require("utils.struct.class")

CRdbmsSession = createClass({
    pStorageStmt = CPreparedStorage:new(),
    pCon = nil
})

function CRdbmsSession:get_storage_statements()
    return self.pStorageStmt
end

function CRdbmsSession:load_call()  -- I/O due to temporary
    local tpTable = load_file_resultset("call.txt") or {}
    save_file_resultset("call.txt", {})

    local st = ""
    for k, v in pairs(tpTable) do
        st = st .. tostring(k) .. ":" .. tostring(v) .. " "
    end
    log_st(LPath.DB, "db.txt", " RECV || " .. st)

    return tpTable
end

function CRdbmsSession:store_call(rgpArgs)
    local tpTable = load_file_resultset("call.txt") or {}
    tpTable[rgpArgs] = 1

    local st = ""
    for k, v in pairs(tpTable) do
        st = st .. tostring(k) .. ":" .. tostring(v) .. " "
    end
    log_st(LPath.DB, "db.txt", " CALL || " .. st)

    save_file_resultset("call.txt", tpTable)
end

function CRdbmsSession:pop_result(rgpArgs)
    local tpTable = load_file_resultset("response.txt") or {}

    local tpRes = tpTable[rgpArgs]
    if tpRes ~= nil then
        tpTable[rgpArgs] = nil
        save_file_resultset("response.txt", tpTable)

        local st = ""
        for k, v in pairs(tpRes) do
            st = st .. tostring(k) .. ":" .. tostring(v) .. " "
        end
        log_st(LPath.DB, "db.txt", " >> " .. st)

        return tpRes, next(tpTable) == nil
    else
        return nil
    end
end

function CRdbmsSession:store_result(rgpArgs)
    local tpTable = load_file_resultset("response.txt") or {}
    tpTable[rgpArgs] = 1

    local st = ""
    for k, v in pairs(tpTable) do
        st = st .. tostring(k) .. ", "
    end
    log_st(LPath.DB, "db.txt", " << " .. st .. " | " .. " INS " .. tostring(rgpArgs))

    save_file_resultset("response.txt", tpTable)
end

function CRdbmsSession:store_all_results(tpArgs)
    local tpTable = load_file_resultset("response.txt") or {}

    for rgpArgs, _ in pairs(tpArgs) do
        tpTable[rgpArgs] = 1
    end

    local st2 = ""
    for k, v in pairs(tpTable) do
        st2 = st2 .. tostring(k) .. ", "
    end

    local st = ""
    for k, v in pairs(tpArgs) do
        st = st .. tostring(k) .. ", "
    end
    log_st(LPath.DB, "db.txt", " << " .. st .. " | " .. " INS [" .. tostring(st2) .. "]")

    save_file_resultset("response.txt", tpTable)
end

function CRdbmsSession:get_rdbms_con()
    return self.pCon
end

function CRdbmsSession:set_rdbms_con(pCon)
    self.pCon = pCon
end
