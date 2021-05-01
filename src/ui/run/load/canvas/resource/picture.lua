--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("ui.constant.view.item")
require("ui.constant.view.resource")
require("ui.run.draw.canvas.inventory.item")
require("ui.struct.component.canvas.resource.tab.grid")

function load_resource_picture(pVwRsc)
    local bUseShadow = pVwRsc:get_type() == RResourceTable.TAB.ITEMS.ID

    local pImgRsc = pVwRsc:get_image()
    local pRscGrid = tpRscGrid[pVwRsc:get_type()]

    local iOx, iOy = pVwRsc:get_image_origin()

    local pVwCnvRsc = load_item_canvas(pImgRsc, pRscGrid.W, pRscGrid.H, RItemTile.INVENTORY, bUseShadow, iOx, iOy)
    return pVwCnvRsc
end
