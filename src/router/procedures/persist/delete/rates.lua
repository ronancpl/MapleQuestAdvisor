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
require("utils.persist.rdbms")
require("utils.provider.json.encode")

function delete_rates(pInfoSrv)
    local sJson = encode_stream(pInfoSrv:get_exp_rate(), pInfoSrv:get_meso_rate(), pInfoSrv:get_drop_rate())

    local pEnv, pCon = rdbms_new(RPersistPath.RATES)
    rdbms_kv_delete(pCon, RPersistKey.DEFAULT)
    rdbms_close(pCon, pEnv)
end
