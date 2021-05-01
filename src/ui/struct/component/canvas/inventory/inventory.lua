--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("ui.constant.input")
require("ui.run.update.canvas.inventory.table")
require("ui.struct.component.element.rect")
require("ui.struct.window.element.basic.slider")
require("utils.procedure.copy")
require("utils.procedure.unpack")
require("utils.struct.class")

CInvtElem = createClass({
    eBox = CUserboxElem:new(),
    pSlider = CWndSlider:new(),

    pInvt,
    iSlctTab,
    iSlctRow,

    nVwItems,

    rgpVwItems = {},
    rgiCurRange = {0, -1},
    rgpTabVwItems = {}
})

function CInvtElem:get_object()
    return self.eBox
end

function CInvtElem:get_slider()
    return self.pSlider
end

function CInvtElem:set_origin(iPx, iPy)
    local pImgBgrd = ctVwInvt:get_background()
    local iW, iH = pImgBgrd:getDimensions()

    self.eBox:load(iPx, iPy, iW, iH)
end

function CInvtElem:get_origin()
    return self.eBox:get_origin()
end

function CInvtElem:get_tab_selected()
    return self.iSlctTab
end

function CInvtElem:set_tab_selected(iTab)
    self.iSlctTab = iTab
end

function CInvtElem:get_row_selected()
    return self.iSlctRow
end

function CInvtElem:set_row_selected(iRow)
    self.iSlctRow = iRow
end

function CInvtElem:get_num_items()
    return #self.rgpVwItems
end

function CInvtElem:get_view_items()
    return self.rgpVwItems
end

function CInvtElem:get_tab_items()
    return self.rgpTabVwItems
end

function CInvtElem:clear_tab_items()
    local m_rgpTabVwItems = self.rgpTabVwItems

    local nTabs = #m_rgpTabVwItems
    clear_table(m_rgpTabVwItems)

    for i = 1, nTabs, 1 do
        m_rgpTabVwItems[i] = {}
    end
end

function CInvtElem:add_tab_items(iTab, rgpVwItems)
    local m_rgpTabVwItems = self.rgpTabVwItems
    table_append(m_rgpTabVwItems[iTab], rgpVwItems)
end

function CInvtElem:_set_view_items(rgpVwItems)
    local m_rgpVwItems = self.rgpVwItems
    clear_table(m_rgpVwItems)
    table_append(m_rgpVwItems, rgpVwItems)
end

function CInvtElem:refresh_view_items()
    local rgpTabVwItems = self:get_tab_items()
    local iTab = self:get_tab_selected()

    local rgpVwItems = rgpTabVwItems[iTab]
    self:_set_view_items(rgpVwItems)
end

function CInvtElem:get_view_range()
    local m_rgiCurRange = self.rgiCurRange
    return m_rgiCurRange[1], m_rgiCurRange[2]
end

function CInvtElem:set_view_range(iIdxFrom, iIdxTo)
    local m_rgiCurRange = self.rgiCurRange
    m_rgiCurRange[1] = iIdxFrom
    m_rgiCurRange[2] = iIdxTo
end

function CInvtElem:reload_inventory(pInvt)
    local m_rgpTabVwItems = self.rgpTabVwItems
    for i = 1, 5, 1 do
        m_rgpTabVwItems[i] = {}
    end

    update_items_for_inventory(self, pInvt)
end

function CInvtElem:load(pInvt, iPx, iPy)
    local pImg = ctVwInvt:get_background()
    local iW, iH = pImg:getDimensions()
    self.eBox:load(iPx, iPy, iW, iH)

    self.pSlider:load(RSliderState.NORMAL, RInventory.VW_INVT_SLIDER.H, true, true, RInventory.VW_INVT_SLIDER.X, RInventory.VW_INVT_SLIDER.Y)
    self:reload_inventory(pInvt)
end

function CInvtElem:update(dt)
    -- do nothing
end

function CInvtElem:draw()
    draw_table_player_inventory(self)
end

function CInvtElem:_try_click_tab(iPx, iPy)
    local iOx, iOy = self:get_origin()

    local iTx = iOx + RInventory.VW_INVT_TAB.NAME.X
    local iTy = iOx + RInventory.VW_INVT_TAB.NAME.Y
    if math.between(iPx, iTx, iTx + 5 * RInventory.VW_INVT_TAB.W) and math.between(iPy, iTy, iTy + RInventory.VW_INVT_TAB.H) then
        local iTab = math.floor((iPx - iTx) / RInventory.VW_INVT_TAB.W)
        update_tab_for_inventory(self, iTab)
    end
end

function CInvtElem:onmousereleased(x, y, button)
    local iTabWidth = RInventory.VW_INVT_TAB.W
    local iTabHeight = RInventory.VW_INVT_TAB.H

    if button == 1 then
        self:_try_click_tab(x, y)
    end
end

function CInvtElem:onwheelmoved(dx, dy)
    local iAdy = math.abs(dy)
    if iAdy >= LInput.MOUSE_WHEEL_MOVE_DY then
        local iDlt = -1 * (dy / iAdy)   -- increase on roll-down

        local iNextSlct = self:get_row_selected() + iDlt

        update_row_for_inventory(self, iNextSlct)
        iNextSlct = self:get_row_selected()

        local m_pSlider = self.pSlider
        m_pSlider:set_current(iNextSlct)
    end
end
