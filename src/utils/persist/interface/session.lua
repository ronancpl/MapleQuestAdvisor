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
require("utils.struct.class")

CRdbmsSession = createClass({
    pStorageStmt = CPreparedStorage:new(),

    tpCall = {},
    tpRes = {},

    pCon = nil
})

function CRdbmsSession:get_storage_statements()
    return self.pStorageStmt
end

function CRdbmsSession:get_table_calls()
    return self.tpCall
end

function CRdbmsSession:get_table_results()
    return self.tpRes
end

function CRdbmsSession:get_rdbms_con()
    return self.pCon
end

function CRdbmsSession:set_rdbms_con(pCon)
    self.pCon = pCon
end
