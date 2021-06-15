--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

package.path = package.path .. ';?.lua'

require("composer.loot.refine")
require("router.procedures.persist.delete.rates")
require("router.procedures.persist.delete.player.character")
require("router.procedures.persist.delete.player.inventory")
require("router.procedures.persist.load.rates")
require("router.procedures.persist.load.player.character")
require("router.procedures.persist.load.player.inventory")
require("router.procedures.persist.save.rates")
require("router.procedures.persist.save.player.character")
require("router.procedures.persist.save.player.inventory")
require("structs.player")
require("structs.storage.inventory")
require("ui.run.build.canvas.stat.server")
require("utils.logger.error")
require("utils.logger.file")

log(LPath.INTERFACE, "load.txt", "Loading persisted data")

ctRefine = load_resources_refine()
local pInfoSrv = CServerInfoTable:new({siExpRate= 10, siMesoRate= 10, siDropRate= 10})

local pIvtItems = CInventory:new()
pIvtItems:add_item(1002067, 1)      -- outfit FTW
pIvtItems:add_item(1402046, 1)
pIvtItems:add_item(1082140, 1)
pIvtItems:add_item(1060091, 7)
pIvtItems:add_item(1072154, 7)
pIvtItems:add_item(1040103, 7)

pIvtItems:add_item(3010000, 4)
pIvtItems:add_item(3010001, 2)
pIvtItems:add_item(3010002, 2)
pIvtItems:add_item(3010003, 2)
pIvtItems:add_item(3010004, 2)
pIvtItems:add_item(3010005, 2)
pIvtItems:add_item(3010006, 2)

pIvtItems:add_item(2010000, 4)
pIvtItems:add_item(2010001, 1)
pIvtItems:add_item(2010002, 4)
pIvtItems:add_item(2010003, 1)
pIvtItems:add_item(2010004, 4)
pIvtItems:add_item(2010005, 1)
pIvtItems:add_item(2010006, 4)
pIvtItems:add_item(4010000, 4)
pIvtItems:add_item(4010001, 1)
pIvtItems:add_item(4010002, 4)
pIvtItems:add_item(4010003, 1)
pIvtItems:add_item(4010004, 4)
pIvtItems:add_item(4010005, 1)
pIvtItems:add_item(4010006, 4)

local pPlayer = CPlayer:new({iId = 1, iMapid = 110000000, siLevel = 50, siJob = 122})
pPlayer:get_items():get_inventory():include_inventory(pIvtItems)

save_player(pPlayer)
save_inventory(pPlayer)
save_rates(pInfoSrv)

log(LPath.DB, "rdbms.txt", "Saving data")

load_rates(pInfoSrv)
load_inventory(pPlayer)
load_player(pPlayer)

log(LPath.DB, "rdbms.txt", "Loading data")

delete_rates(pInfoSrv)
delete_inventory(pPlayer)
delete_player(pPlayer)

log(LPath.DB, "rdbms.txt", "Deleting data")
