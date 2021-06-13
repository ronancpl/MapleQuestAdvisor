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
require("utils.persist.act.call")
require("utils.provider.json.encode")

function delete_rates(pInfoSrv)
    local pCon = db_new(RPersistPath.DB)
    db_kv_delete(pCon, RPersistPath.RATES, "id", RPersistKey.DEFAULT)

    local sJson = db_kv_select(pCon, RPersistPath.RATES, "content", db_pk_table(RPersistTable.RATES), RPersistKey.DEFAULT)
    log_st(LPath.DB, "_delete.txt", "RATES : '" .. tostring(sJson) .. "'")

    db_close(pCon)
end
