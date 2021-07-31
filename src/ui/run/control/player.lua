--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("router.procedures.persist.delete.player.character")
require("router.procedures.persist.delete.player.inventory")
require("router.procedures.persist.load.player.character")
require("router.procedures.persist.load.player.inventory")
require("router.procedures.persist.save.player.character")
require("router.procedures.persist.save.player.inventory")

function run_player_bt_load(pPlayer)
    load_player(pPlayer)
    load_inventory(pPlayer)
end

function run_player_bt_save(pPlayer)
    save_player(pPlayer)
    save_inventory(pPlayer)
end

function run_player_bt_delete(pPlayer)
    delete_inventory(pPlayer)
    delete_player(pPlayer)
end
