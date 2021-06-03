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

local function fetch_player_data(pPlayer)
    local tpData = pPlayer:export_table()
    return tpData
end

function save_player(pPlayer)
    local sPlayerInfo = fetch_player_data(pPlayer)
    local sJson = encode_item(sPlayerInfo)

    local pEnv, pCon = db_new(RPersistPath.STAT)

    db_kv_add(pCon, pPlayer:get_id(), sJson)

    db_close(pCon, pEnv)
end
