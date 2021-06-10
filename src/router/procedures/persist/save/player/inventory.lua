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
require("utils.procedure.copy")
require("utils.provider.json.encode")

local function fetch_inventory_data(pPlayer)
    local tpData = pPlayer:export_inventory_tables()
    return (tpData)
end

function save_inventory(pPlayer)
    local sInvtInfo = fetch_inventory_data(pPlayer)
    local sJson = encode_item(sInvtInfo)

    local pCon = db_new(RPersistPath.DB)
    db_kv_add(pCon, RPersistPath.INVENTORY, db_pk_table(RPersistTable.INVENTORY), {pPlayer:get_id(), sJson})

    local sJson = db_kv_select(pCon, RPersistPath.INVENTORY, "content", db_pk_table(RPersistTable.INVENTORY), RPersistKey.DEFAULT)
    log_st(LPath.DB, "_save.txt", tostring(RPersistPath.INVENTORY) .. " >> '" .. sJson .. "'")

    db_close(pCon)
end
