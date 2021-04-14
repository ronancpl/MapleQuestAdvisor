--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("router.procedures.constant")
require("ui.constant.input")
require("ui.constant.style")
require("ui.run.draw.canvas.inventory.inventory")
require("ui.struct.component.element.rect")
require("ui.struct.component.canvas.inventory.item")
require("ui.struct.window.element.basic.slider")
require("utils.procedure.copy")
require("utils.struct.class")

CInvtElem = createClass({
    eBox = CUserboxElem:new(),
    pSlider = CWndSlider:new(),

    pInvt,
    iSlctTab,
    iSlctRow,
    iNewIt,

    rgpVwItems = {},
    rgiCurRange = {-1, -1},
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

function CInvtElem:_set_row_selected(iRow)
    self.iSlctRow = iRow
end

function CInvtElem:_fetch_item_range()
    local m_rgpVwItems = self.rgpVwItems

    local iRow = self:get_row_selected() - 1
    local iSt = (iRow * 4) + 1
    local iEn = math.min(#m_rgpVwItems, (iRow + 6) * 4)

    return iSt, iEn
end

function CInvtElem:fetch_item_palette()
    local m_rgpVwItems = self.rgpVwItems

    local rgpItems = {}
    local iSt, iEn = unpack(self.rgiCurRange)
    for i = iSt, iEn, 1 do
        table.insert(rgpItems, m_rgpVwItems[i])
    end

    return rgpItems
end

function CInvtElem:_clear_current_item_range()
    local m_rgpVwItems = self.rgpVwItems
    local iSt, iEn = unpack(self.rgiCurRange)

    for i = iSt, iEn, 1 do
        local pVwItem = m_rgpVwItems[i]
        if pVwItem ~= nil then
            pVwItem:update(-1, -1)
        end
    end
end

function CInvtElem:_update_item_position()
    local m_rgpVwItems = self.rgpVwItems

    local iSt, iEn = self:_fetch_item_range()
    self:_clear_current_item_range()

    self.rgiCurRange = {iSt, iEn}

    local m_eBox = self.eBox
    local iPx, iPy = m_eBox:get_origin()

    iPx = iPx + RStylebox.VW_INVT_ITEM.X + RStylebox.VW_INVT_ITEM.ST_X
    iPy = iPy + RStylebox.VW_INVT_ITEM.Y + RStylebox.VW_INVT_ITEM.ST_Y

    local iIx, iIy

    local iPos = iSt - 1
    local iBr = math.floor(iPos / 4)

    for i = iSt, iEn, 1 do
        local iPos = i - 1
        local iR = math.floor(iPos / 4)
        local iC = iPos % 4

        iIx = iPx + iC * (RStylebox.VW_INVT_ITEM.W + RStylebox.VW_INVT_ITEM.FIL_X)
        iIy = iPy + (iR - iBr) * (RStylebox.VW_INVT_ITEM.H + RStylebox.VW_INVT_ITEM.FIL_Y)

        local pVwItem = m_rgpVwItems[i]
        if pVwItem ~= nil then
            pVwItem:update(iIx, iIy)
        end
    end
end

function CInvtElem:update_row(iNextSlct)
    local m_pInvt = self.pInvt

    local iRow = math.iclamp(iNextSlct, 1, math.max(math.ceil(m_pInvt:size() / 4), 0))
    self:_set_row_selected(iRow)
    self:_update_item_position(iRow)
end

function CInvtElem:update_tab(iNextTab)
    local m_rgpTabVwItems = self.rgpTabVwItems

    local iTab = math.iclamp(iNextTab + 1, 1, #m_rgpTabVwItems)
    self:set_tab_selected(iTab)

    local rgpVwIts = m_rgpTabVwItems[iTab]

    local m_rgpVwItems = self.rgpVwItems
    clear_table(m_rgpVwItems)
    table_append(m_rgpVwItems, rgpVwIts)

    self:update_row(0)  -- set to list start
end

function CInvtElem:update_inventory(pInvt)
    self.pInvt = pInvt
    self.iSlctTab = 1
    self.iNewIt = -1
    self.iSlctRow = 0

    local m_rgpTabVwItems = self.rgpTabVwItems
    clear_table(m_rgpTabVwItems)

    for i = 1, 5, 1 do
        m_rgpTabVwItems[i] = {}
    end

    for iId, iCount in pairs(pInvt:get_items()) do
        local siType = math.floor(iId / 1000000)

        local pVwItem = CCanvasItem:new()
        pVwItem:load(iId, iCount)

        local rgpVwItems = m_rgpTabVwItems[siType]
        table.insert(rgpVwItems, pVwItem)
    end

    self:update_tab(0)  -- set to EQUIP

    local m_pSlider = self.pSlider

    local m_rgpVwItems = self.rgpVwItems
    local iSgmts = math.ceil(#m_rgpVwItems / 4)

    m_pSlider:set_num_segments(iSgmts)
end

function CInvtElem:load(pInvt, iPx, iPy)
    local pImg = ctVwInvt:get_background()
    local iW, iH = pImg:getDimensions()
    self.eBox:load(iPx, iPy, iW, iH)

    self.pSlider:load(RSliderState.NORMAL, RStylebox.VW_INVT_SLIDER.H, true, true)

    self:update_inventory(pInvt)
end

function CInvtElem:update(dt)
    -- do nothing
end

function CInvtElem:draw()
    draw_player_inventory(self)
end

function CInvtElem:_try_click_tab(iPx, iPy)
    local iOx, iOy = self:get_origin()

    local iTx = iOx + RStylebox.VW_INVT_TAB.NAME.X
    local iTy = iOx + RStylebox.VW_INVT_TAB.NAME.Y
    if math.between(iPx, iTx, iTx + 170) and math.between(iPy, iTy, iTy + RStylebox.VW_INVT_TAB.H) then
        local iTab = math.floor((iPx - iTx) / (170 / 5))
        self:update_tab(iTab)
    end
end

function CInvtElem:onmousereleased(x, y, button)
    local iTabWidth = RStylebox.VW_INVT_TAB.W
    local iTabHeight = RStylebox.VW_INVT_TAB.H

    if button == 1 then
        self:_try_click_tab(x, y)
    end
end

function CInvtElem:onwheelmoved(dx, dy)
    local iAdy = math.abs(dy)
    if iAdy >= LInput.MOUSE_WHEEL_MOVE_DY then
        local iDlt = -1 * (dy / iAdy)   -- increase on roll-down

        local iNextSlct = self:get_row_selected() + iDlt

        self:update_row(iNextSlct)
        iNextSlct = self:get_row_selected()

        local m_pSlider = self.pSlider
        m_pSlider:set_current(iNextSlct)
    end
end
