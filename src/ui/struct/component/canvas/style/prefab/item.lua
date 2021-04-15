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
require("ui.constant.view.style")
require("ui.run.draw.canvas.inventory.item")
require("ui.struct.component.element.rect")
require("ui.struct.window.summary")
require("utils.struct.class")

CStyleBoxItem = createClass({
    eBox = CUserboxElem:new(),
    iRy,    -- position: textbox title + whitespace

    pImgItem
})

function CStyleBoxItem:get_object()
    return self.eBox
end

function CStyleBoxItem:load(pItemImgData, iRx, iRy)
    self.eBox:load(iRx, iRy, RStylebox.VW_ITEM.W, RStylebox.VW_ITEM.H)

    if pItemImgData ~= nil then
        self.pImgItem = love.graphics.newImage(pItemImgData)
        self.iRy = iRy
    end
end

function CStyleBoxItem:draw(iPx, iPy)
    local m_pImgItem = self.pImgItem
    if m_pImgItem ~= nil then
        iPx = iPx + RStylebox.FIL_X
        iPy = iPy + RStylebox.FIL_Y

        ae = 1
        draw_item_canvas(m_pImgItem, nil, iPx, iPy, RStylebox.VW_ITEM.W, RStylebox.VW_ITEM.H)
        ae = nil
    end
end
