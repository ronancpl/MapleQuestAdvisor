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

local function load_inventory_data(sJson)
    local rgpInvtItems = {}

    local rgsInvtInfo = decode_item(sJson)
    for iId, tiInvt in pairs(rgsInvtInfo) do
        local tsInvt = {}
        for iId2, iItem in pairs(decode_item(tiInvt)) do
            tsInvt["\"" .. iId2 .. "\""] = iItem
        end
        rgpInvtItems[iId] = tsInvt
    end

    return rgpInvtItems
end

function load_inventory(pPlayer)
    local pCon = db_new(RPersistPath.DB)
    local sJson = db_kv_select(pCon, RPersistPath.INVENTORY, "content", db_pk_table(RPersistTable.INVENTORY), pPlayer:get_id())
    db_close(pCon)

    if sJson ~= nil then
        local rgpInvts = load_inventory_data(sJson)
        pPlayer:import_inventory_tables(rgpInvts)
    end
end
