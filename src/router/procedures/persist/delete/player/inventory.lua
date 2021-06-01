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
require("utils.provider.json.decode")

function delete_inventory(pPlayer)
    local pEnv, pCon = rdbms_new(RPersistPath.INVENTORY)
    rdbms_kv_delete(pCon, pPlayer:get_id())
    rdbms_close(pCon, pEnv)
end
