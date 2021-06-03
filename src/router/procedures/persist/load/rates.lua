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
require("utils.provider.json.decode")

function load_rates(pInfoSrv)
    local pEnv, pCon = db_new(RPersistPath.RATES)
    local sJson = db_kv_fetch(pCon, RPersistKey.DEFAULT)
    db_close(pCon, pEnv)

    local iExpR, iMesoR, iDropR = decode_stream(sJson)
    pInfoSrv:set_exp_rate(iExpR)
    pInfoSrv:set_meso_rate(iMesoR)
    pInfoSrv:set_drop_rate(iDropR)
end
