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
    local iLx, iTy, _, _ = pSlctBox:get_ltrb()

    local eBox = pSlctBox:get_cover_box()
    eBox:draw(iLx, iTy)

    local pTxtSlct = pSlctBox:get_text_selected()
    if pTxtSlct ~= nil then
        --pTxtSlct
        pFontOngoingQuest = love.graphics.newFont(RWndPath.LOVE_FONT_DIR_PATH .. "arial.ttf", 12)
        pTxtOngoingQuest = love.graphics.newText(pFontOngoingQuest)
        pTxtOngoingQuest:setf({{0, 0, 0}, pSlctBox:get_text_opt()}, RActionElement.NAV_QUEST.LINE_WIDTH, "center")

        love.graphics.draw(pTxtOngoingQuest, iLx + RSelectbox.VW_SELECTBOX.LINE_ST_W, iTy + RSelectbox.VW_SELECTBOX.LINE_ST_H)
        --pSlctBox:free_visible_item(pTxtSlct)
    end
end

local function draw_selectbox_items(pSlctBox)
    if pSlctBox:get_extended() == nil then
        return
    end

    local iLx, iTy, _, iBy = pSlctBox:get_ltrb()

    local rgpBoxItems = pSlctBox:fetch_visible_items()

    love.graphics.setColor(0.77, 0.77, 0.77)
    love.graphics.rectangle("fill", iLx, iBy, RSelectbox.VW_SELECTBOX.LINE_W, math.min(#rgpBoxItems, RSelectbox.VW_SELECTBOX.NUM_LINES) * RSelectbox.VW_SELECTBOX.LINE_H)
    love.graphics.setColor(1, 1, 1)

    local iPx = iLx
    local iPy = iBy

    for _, pTxtSlct in ipairs(rgpBoxItems) do
        love.graphics.draw(pTxtSlct, iPx + RSelectbox.VW_SELECTBOX.LINE_ST_W, iPy + RSelectbox.VW_SELECTBOX.LINE_ST_H)
        iPy = iPy + RSelectbox.VW_SELECTBOX.LINE_H
    end

    local iPx = iLx
    local iPy = iBy
    local iSlct = pSlctBox:get_opt()
    if iSlct ~= nil then
        love.graphics.setColor(0.44, 0.44, 0.44)
        love.graphics.rectangle("fill", iPx, iPy + ((iSlct - 1) * RSelectbox.VW_SELECTBOX.LINE_H), RSelectbox.VW_SELECTBOX.LINE_W, RSelectbox.VW_SELECTBOX.LINE_H)
        love.graphics.setColor(1, 1, 1)

        local pTxtSlct = rgpBoxItems[iSlct]
        love.graphics.draw(pTxtSlct, iPx + RSelectbox.VW_SELECTBOX.LINE_ST_W, iPy + ((iSlct - 1) * RSelectbox.VW_SELECTBOX.LINE_H) + RSelectbox.VW_SELECTBOX.LINE_ST_H)
    end

    --pSlctBox:free_visible_items(rgpBoxItems)
end

function draw_selectbox(pSlctBox)
    draw_selectbox_cover(pSlctBox)
    draw_selectbox_items(pSlctBox)
end
