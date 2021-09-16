--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("ui.constant.view.resource")
require("ui.run.update.canvas.resource.tab.grid")
require("ui.run.update.canvas.resource.tab.info")
require("ui.run.update.canvas.resource.tab.pict")

tfn_rsc_update_row = {update_row_for_resource_grid, update_row_for_resource_pict, update_row_for_resource_info}
tfn_rsc_update_tab = {update_tab_for_resource_grid, update_tab_for_resource_pict, update_tab_for_resource_info}
tfn_rsc_update_items = {update_items_for_resource_grid, update_items_for_resource_pict, update_items_for_resource_info}

rgiRscTabType = {RResourceTable.TAB.MOBS.TYPE, RResourceTable.TAB.ITEMS.TYPE, RResourceTable.TAB.NPC.TYPE, RResourceTable.TAB.FIELD_ENTER.TYPE, RResourceTable.TAB.REWARD.TYPE}
