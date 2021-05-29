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
require("utils.persist.nosql")
require("utils.provider.json.decode")

function load_rates(pInfoSrv)
    local pCon = nsql_new()
    local sJson = nsql_kv_fetch(pCon, RPersistPath.RATES, RPersistKey.DEFAULT)
    nsql_close(pCon)

    local iExpR, iMesoR, iDropR = decode_stream(sJson)
    pInfoSrv:set_exp_rate(iExpR)
    pInfoSrv:set_meso_rate(iMesoR)
    pInfoSrv:set_drop_rate(iDropR)
end
