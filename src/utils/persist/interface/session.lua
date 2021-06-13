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
require("utils.persist.statements")
require("utils.persist.serial.table")
require("utils.procedure.copy")
require("utils.struct.class")

CRdbmsSession = createClass({
    pStorageStmt = CPreparedStorage:new(),
    sDataSource = nil
})

function CRdbmsSession:get_storage_statements()
    return self.pStorageStmt
end

function CRdbmsSession:load_call()  -- I/O due to temporary session
    local tpTable = reset_file_resultset(RPersistFile.RS_CALL) or {}
    return tpTable
end

function CRdbmsSession:store_call(rgpArgs)
    local tpTable = load_file_resultset(RPersistFile.RS_CALL) or {}

    local sKeyArgs = tostring(rgpArgs)
    tpTable[sKeyArgs] = rgpArgs         -- insert new DB operation request

    save_file_resultset(RPersistFile.RS_CALL, tpTable)
end

function CRdbmsSession:pop_result(rgpArgs)
    local tpTable = load_file_resultset(RPersistFile.RS_RDBMS) or {}

    local sKeyArgs = tostring(rgpArgs)
    local tpRes = tpTable[sKeyArgs]
    if tpRes ~= nil then
        tpTable[sKeyArgs] = nil
        save_file_resultset(RPersistFile.RS_RDBMS, tpTable)

        return tpRes, next(tpTable) == nil
    else
        return nil
    end
end

function CRdbmsSession:store_result(rgpArgs)
    local tpTable = load_file_resultset(RPersistFile.RS_RDBMS) or {}
    tpTable[rgpArgs] = 1

    save_file_resultset(RPersistFile.RS_RDBMS, tpTable)
end

function CRdbmsSession:store_all_results(tpArgs)
    local tpTable = load_file_resultset(RPersistFile.RS_RDBMS) or {}
    table_merge(tpTable, tpArgs)

    save_file_resultset(RPersistFile.RS_RDBMS, tpTable)
end

function CRdbmsSession:get_rdbms_ds()
    return self.sDataSource
end

function CRdbmsSession:set_rdbms_ds(sDs)
    self.sDataSource = sDs
end
