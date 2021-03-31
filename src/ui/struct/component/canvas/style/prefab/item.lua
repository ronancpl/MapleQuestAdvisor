--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("ui.constant.path")
require("ui.run.draw.canvas.inventory.item")
require("ui.struct.component.basic.base")
require("utils.struct.class")

CStyleBoxItem = createClass({
    eElem = CBasicElem:new(),
    iRy,    -- position: textbox title + whitespace

    pImgItem
})

function CStyleBoxItem:load(pItemImgData, iRx, iRy)
    self.eElem:load(0, 0)

    if pItemImgData ~= nil then
        self.pImgItem = love.graphics.newImage(pItemImgData)
        self.iRy = iRy
    end
end

function CStyleBoxItem:draw(iPx, iPy)
    local m_pImgItem = self.pImgItem
    if m_pImgItem ~= nil then
        local m_eElem = self.eElem
        local iRx, iRy = m_eElem:get_pos()

        iPx = iPx + iRx + RStylebox.FIL_X
        iPy = iPy + iRy + RStylebox.FIL_Y

        draw_item_canvas(m_pImgItem, nil, iPx, iPy, RStylebox.VW_ITEM.W, RStylebox.VW_ITEM.H)
    end
end