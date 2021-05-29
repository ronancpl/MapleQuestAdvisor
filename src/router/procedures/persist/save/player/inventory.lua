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
require("utils.provider.json.encode")

local function fetch_inventory_data(pPlayer)
    local tpData = pPlayer:export_inventory_tables()
    return tpData
end

function save_inventory(pPlayer)
    local sInvtInfo = fetch_inventory_data(pPlayer)
    local sJson = encode_item(sInvtInfo)

    local pCon = nsql_new()

    nsql_kv_add(pCon, RPersistPath.INVENTORY, pPlayer:get_id(), sJson)

    nsql_close(pCon)
end
