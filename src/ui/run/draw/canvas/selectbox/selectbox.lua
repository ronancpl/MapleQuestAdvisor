--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("ui.constant.view.selectbox")
require("ui.struct.toolkit.graphics")

local function draw_selectbox_cover(pSlctBox)
    local pBox = pSlctBox:get_cover_box()
    local iOx, iOy, _, _ = pBox:get_ltrb()
    pBox:draw(iOx, iOy)

    local pTxtSlct = pSlctBox:get_text_selected()
    if pTxtSlct ~= nil then
        graphics_draw(pTxtSlct, iOx, iOy)
    end
end

local function draw_selectbox_items(pSlctBox)
    local rgsTxt = pSlctBox:get_cover_box()

    local eBox = pSlctBox:get_cover_box()
    local iLx, _, _, iBy = eBox:get_ltrb()

    local iPx = iLx + RSelectbox.VW_SELECTBOX.LINE_ST_W
    local iPy = iBy + RSelectbox.VW_SELECTBOX.LINE_H

    local rgpBoxItems = pSlctBox:fetch_visible_items()
    for _, pTxtSlct in ipairs(rgpBoxItems) do
        graphics_draw(pTxtSlct, iPx, iPy)
        iPy = iPy + RSelectbox.VW_SELECTBOX.LINE_H
    end
end

function draw_selectbox(pSlctBox)
    draw_selectbox_cover(pSlctBox)
    draw_selectbox_items(pSlctBox)
end
