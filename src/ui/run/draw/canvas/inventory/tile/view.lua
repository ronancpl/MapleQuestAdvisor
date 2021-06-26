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
require("ui.run.draw.canvas.inventory.tile.desc")
require("ui.run.draw.canvas.inventory.tile.item")
require("ui.struct.toolkit.canvas")

local tfn_tile_draw = {}
tfn_tile_draw[RItemTile.INVENTORY] = fetch_item_tile_box_invt
tfn_tile_draw[RItemTile.DESC] = fetch_item_tile_box_desc

function draw_canvas_item_tile(pImgItem, iWidth, iHeight, siType, bUseShadow, iOx, iOy)
    local iPx, iPy = 0, 0

    iOx = iOx or 0
    iOy = iOy or 0

    -- draw item background
    local pImgShd = ctVwInvt:get_shadow()

    local fn_tile_draw = tfn_tile_draw[siType]
    local iCx, iCy, iImgX, iImgY, iImgW, iImgH, iShPx, iShPy, iShW, _ = fn_tile_draw(pImgItem, pImgShd, iPx, iPy, iWidth, iHeight)

    if bUseShadow then
        -- draw shadow
        graphics_canvas_draw(pImgShd, iShPx, iShPy, 0, iShW, nil)
    end

    -- draw item image
    graphics_canvas_draw(pImgItem, iImgX, iImgY, 0, iImgW, iImgH)
end
