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
require("ui.run.update.canvas.resource.common")

function update_row_for_resource_grid(pVwRscs, iNextSlct)
    update_row_for_resource_table(pVwRscs, iNextSlct, RResourceTable.VW_GRID)
end

function update_tab_for_resource_grid(pVwRscs, iNextTab)
    update_tab_for_resource_table(pVwRscs, iNextTab)
end

function update_items_for_resource_grid(pVwRscs, pRscProp)
    update_items_for_resource_table(pVwRscs, pRscProp, RResourceTable.VW_GRID)
end
