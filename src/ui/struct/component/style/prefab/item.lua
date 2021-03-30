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
require("ui.struct.component.basic.base")
require("ui.struct.toolkit.color")
require("ui.struct.toolkit.graphics")
require("utils.struct.class")

CStyleBoxItem = createClass({
    eElem = CBasicElem:new(),
    iRy,    -- position: textbox title + whitespace

    pImgItem,
    pImgShd
})

function CStyleBoxItem:load(pItemImgData, iRx, iRy)
    self.eElem:load(0, 0)

    if pItemImgData ~= nil then
        self.pImgItem = love.graphics.newImage(pItemImgData)

        local pImgData = pFrameStylebox:get_image_data(RWndPath.INTF_ITEM_SHADOW)
        self.pImgShd = love.graphics.newImage(pImgData)

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

        -- draw item background
        lock_graphics_color(194, 194, 209)
        love.graphics.rectangle("fill", iPx, iPy, RStylebox.VW_ITEM.W, RStylebox.VW_ITEM.H)
        unlock_graphics_color()

        -- draw shadow
        graphics_draw(self.pImgShd, iPx, iPy + 53, 0, RStylebox.VW_ITEM.W, nil)

        -- draw item image
        graphics_draw(m_pImgItem, iPx, iPy, 0, RStylebox.VW_ITEM.W, nil)
    end
end
