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
require("ui.run.update.canvas.position")

function draw_resource_tooltip(pVwRsc)
    local pVwTip = pVwRsc:get_tooltip()

    local pTextbox = pVwTip:get_textbox()
    pTextbox:draw()
end

function draw_resource_link(pVwRsc)
    local eTxtFieldLink = pVwRsc:get_object_field_link()
    eTxtFieldLink:draw()
end

function draw_resource_picture(pVwRsc)
    local bUseShadow = pVwRsc:get_type() == RResourceTable.TAB.ITEMS.ID

    local pVwCnvRsc = pVwRsc:get_picture()
    local iCount = pVwRsc:get_count()

    local iPx, iPy = pVwRsc:get_origin()
    local iRx, iRy = read_canvas_position()

    local rX, rY = pVwRsc:get_image_origin()

    local pRscConfVw = pVwRsc:get_conf()
    draw_item_canvas(pVwCnvRsc, iCount, iPx + iRx, iPy + iRy, pRscConfVw.W, pRscConfVw.H, rX, rY)
end
