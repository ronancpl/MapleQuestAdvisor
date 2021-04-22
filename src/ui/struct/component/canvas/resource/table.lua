--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("ui.constant.view.resource")
require("ui.struct.component.element.texture")
require("ui.struct.window.element.basic.slider")
require("utils.struct.class")

CRscTableElem = createClass({
    eTexture = CTextureElem:new(),
    pSlider = CWndSlider:new(),

    iSlctTab,
    iSlctRow,

    rgpVwItems = {},
    rgiCurRange = {-1, -1},
    rgpTabVwItems = {}
})

function CRscTableElem:get_origin()
    return self.eTexture:get_origin()
end

function CRscTableElem:get_background()
    return self.eTexture
end

function CRscTableElem:get_slider()
    return self.pSlider
end

function CRscTableElem:get_tab_selected()
    return self.iSlctTab
end

function CRscTableElem:set_tab_selected(iTab)
    self.iSlctTab = iTab
end

function CRscTableElem:_fetch_item_range()
    local m_rgpVwItems = self.rgpVwItems

    local iRow = self:get_row_selected() - 1
    local iSt = (iRow * 4) + 1
    local iEn = math.min(#m_rgpVwItems, (iRow + 6) * 4)

    return iSt, iEn
end

function CRscTableElem:_clear_current_item_range()
    local m_rgpVwItems = self.rgpVwItems
    local iSt, iEn = unpack(self.rgiCurRange)

    for i = iSt, iEn, 1 do
        local pVwItem = m_rgpVwItems[i]
        if pVwItem ~= nil then
            pVwItem:update(-1, -1)
        end
    end
end

function CRscTableElem:_update_item_position()
    local m_rgpVwItems = self.rgpVwItems

    local iSt, iEn = self:_fetch_item_range()
    self:_clear_current_item_range()

    self.rgiCurRange = {iSt, iEn}

    local m_eBox = self.eBox
    local iPx, iPy = m_eBox:get_origin()

    iPx = iPx + RInventory.VW_INVT_ITEM.X + RInventory.VW_INVT_ITEM.ST_X
    iPy = iPy + RInventory.VW_INVT_ITEM.Y + RInventory.VW_INVT_ITEM.ST_Y

    local iIx, iIy

    local iPos = iSt - 1
    local iBr = math.floor(iPos / RInventory.VW_INVT.ROWS)

    for i = iSt, iEn, 1 do
        local iPos = i - 1
        local iC = iPos % RInventory.VW_INVT.ROWS

        iIx = iPx + iC * (RInventory.VW_INVT_ITEM.W + RInventory.VW_INVT_ITEM.FIL_X)
        iIy = iPy

        local pVwItem = m_rgpVwItems[i]
        if pVwItem ~= nil then
            pVwItem:update(iIx, iIy)
        end
    end
end

function CRscTableElem:update_row(iNextSlct)
    local m_pInvt = self.pInvt

    local iIvtCols = math.ceil(m_pInvt:size() / RResource.VW_TABLE.ROWS)
    local iRow = math.iclamp(iNextSlct, 1, math.max(iIvtCols, 1))
    self:_set_row_selected(iRow)
    self:_update_item_position(iRow)
end

function CRscTableElem:update_tab(iNextTab)
    local m_rgpTabVwItems = self.rgpTabVwItems

    local iTab = math.iclamp(iNextTab + 1, 1, #m_rgpTabVwItems)
    self:set_tab_selected(iTab)

    local rgpVwIts = m_rgpTabVwItems[iTab]

    local m_rgpVwItems = self.rgpVwItems
    clear_table(m_rgpVwItems)
    table_append(m_rgpVwItems, rgpVwIts)

    self:update_row(0)  -- set to list start
end

function CRscTableElem:update_inventory(pInvt, nTabs)
    self.pInvt = pInvt
    self.iSlctTab = 1
    self.iSlctRow = 0

    local m_rgpTabVwItems = self.rgpTabVwItems
    clear_table(m_rgpTabVwItems)

    for i = 1, nTabs, 1 do
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
    local iSgmts = math.ceil(#m_rgpVwItems / RInventory.VW_INVT.ROWS)

    m_pSlider:set_num_segments(iSgmts)

    local bDisable = iSgmts <= RInventory.VW_INVT.COLS
    if bDisable then
        self.pSlider:update_state(RSliderState.DISABLED)
    else
        self.pSlider:update_state(RSliderState.NORMAL)
    end
end

function CRscTableElem:load(rX, rY, pTextureData)
    local pImgBox, iIx, iIy, iIw, iIh, iOx, iOy, iOw, iOh = pTextureData:get()

    local m_eTexture = self.eTexture
    m_eTexture:load(rX, rY, pImgBox, iIx, iIy, iIw, iIh, iOx, iOy, iOw, iOh)
end

function CRscTableElem:update(dt)
    -- do nothing
end

function CRscTableElem:draw()
    draw_table_resources(self)
end
