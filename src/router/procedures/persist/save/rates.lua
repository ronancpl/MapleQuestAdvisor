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

function save_rates(pInfoSrv)
    local sJson = encode_stream({pInfoSrv:get_exp_rate(), pInfoSrv:get_meso_rate(), pInfoSrv:get_drop_rate()})

    local pCon = db_new(RPersistPath.DB)
    db_kv_add(pCon, RPersistPath.RATES, db_pk_table(RPersistTable.RATES), {RPersistKey.DEFAULT, sJson})

    local sJson = db_kv_select(pCon, RPersistPath.RATES, "content", db_pk_table(RPersistTable.RATES), RPersistKey.DEFAULT)
    log_st(LPath.DB, "_save.txt", "RATES : '" .. sJson .. "'")

    db_close(pCon)
end
