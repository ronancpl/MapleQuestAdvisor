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
require("ui.constant.view.resource")
require("ui.run.draw.canvas.resource.table")
require("ui.run.update.canvas.resource.common")
require("ui.struct.component.canvas.resource.tab.grid")
require("ui.struct.component.canvas.resource.tab.method")
require("ui.struct.component.element.texture")
require("ui.struct.window.element.basic.slider")
require("utils.procedure.copy")
require("utils.procedure.unpack")
require("utils.struct.class")

CRscTableElem = createClass({
    eTexture,
    eFieldTexture,

    pSlider = CSliderElem:new(),

    tpRscGrid,

    iSlctTab,
    iSlctRow,

    rgpVwItems = {},
    rgiCurRange = {0, -1},
    rgpTabVwItems = {abc = "abc"}
})

function CRscTableElem:get_origin()
    return self.eTexture:get_origin()
end

function CRscTableElem:set_position(iPx, iPy)
    self.eTexture:set_origin(iPx, iPy)
end

function CRscTableElem:get_background()
    return self.eTexture
end

function CRscTableElem:get_background_field()
    return self.eFieldTexture
end

function CRscTableElem:get_object()
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

function CRscTableElem:get_row_selected()
    return self.iSlctRow
end

function CRscTableElem:set_row_selected(iRow)
    self.iSlctRow = iRow
end

function CRscTableElem:get_num_items()
    return #self.rgpVwItems
end

function CRscTableElem:get_view_items()
    return self.rgpVwItems
end

function CRscTableElem:get_conf()
    return self.tpRscGrid[self:get_tab_selected()]
end

function CRscTableElem:get_view_range()
    local m_rgiCurRange = self.rgiCurRange
    return m_rgiCurRange[1], m_rgiCurRange[2]
end

function CRscTableElem:set_view_range(iIdxFrom, iIdxTo)
    local m_rgiCurRange = self.rgiCurRange
    m_rgiCurRange[1] = iIdxFrom
    m_rgiCurRange[2] = iIdxTo
end

function CRscTableElem:get_tab_items()
    return self.rgpTabVwItems
end

function CRscTableElem:_free_tab_items()
    local m_rgpTabVwItems = self.rgpTabVwItems
    local nTabs = #m_rgpTabVwItems

    for i = 1, nTabs, 1 do
        local rgpVwItems = m_rgpTabVwItems[i]
        for _, pVwItem in ipairs(rgpVwItems) do
            pVwItem:free()
        end
    end
end

function CRscTableElem:_reset_tab_items()
    local m_rgpTabVwItems = self.rgpTabVwItems
    local nTabs = #m_rgpTabVwItems
    clear_table(m_rgpTabVwItems)

    for i = 1, nTabs, 1 do
        m_rgpTabVwItems[i] = {}
    end
end

function CRscTableElem:clear_tab_items()
    self:_free_tab_items()
    self:_reset_tab_items()
end

function CRscTableElem:add_tab_items(iTab, rgpVwItems)
    local m_rgpTabVwItems = self.rgpTabVwItems
    table_append(m_rgpTabVwItems[iTab], rgpVwItems)
end

function CRscTableElem:_set_view_items(rgpVwItems)
    local m_rgpVwItems = self.rgpVwItems
    clear_table(m_rgpVwItems)
    table_append(m_rgpVwItems, rgpVwItems)
end

function CRscTableElem:refresh_view_items()
    local rgpTabVwItems = self:get_tab_items()
    local iTab = self:get_tab_selected()

    local rgpVwItems = rgpTabVwItems[iTab]
    self:_set_view_items(rgpVwItems)
end

function CRscTableElem:get_fn_update_row()
    local iTab = self:get_tab_selected()
    return tfn_rsc_update_row[rgiRscTabType[iTab]]
end

function CRscTableElem:get_fn_update_tab()
    local iTab = self:get_tab_selected()
    return tfn_rsc_update_tab[rgiRscTabType[iTab]]
end

function CRscTableElem:get_fn_update_items()
    local iTab = self:get_tab_selected()
    return tfn_rsc_update_items[rgiRscTabType[iTab]]
end

function CRscTableElem:load(rX, rY, pTextureData, pFieldTextureData, tpRscGrid)
    local pImgBox, iIx, iIy, iIw, iIh, iOx, iOy, iOw, iOh

    local eTexture = CTextureElem:new()
    pImgBox, iIx, iIy, iIw, iIh, iOx, iOy, iOw, iOh = pTextureData:get()
    eTexture:load(rX, rY, pImgBox, iIx, iIy, iIw, iIh, iOx, iOy, iOw, iOh)
    self.eTexture = eTexture

    local eFieldTexture = CTextureElem:new()
    pImgBox, iIx, iIy, iIw, iIh, iOx, iOy, iOw, iOh = pFieldTextureData:get()
    eFieldTexture:load(rX, rY, pImgBox, iIx, iIy, iIw, iIh, iOx, iOy, iOw, iOh)
    self.eFieldTexture = eFieldTexture

    self.pSlider:load(RSliderState.NORMAL, RResourceTable.VW_SLIDER.H, true, true, RResourceTable.VW_SLIDER.X, RResourceTable.VW_SLIDER.Y)

    local m_rgpTabVwItems = self.rgpTabVwItems
    for i = 1, 4, 1 do
        m_rgpTabVwItems[i] = {}
    end

    self.tpRscGrid = tpRscGrid
end

function CRscTableElem:reset()
    -- do nothing
end

function CRscTableElem:update(dt)
    -- do nothing
end

function CRscTableElem:draw()
    draw_table_resources(self)
end

function CRscTableElem:_try_click_tab(iPx, iPy)
    local iOx, iOy = self:get_origin()

    local iTx = iOx + RResourceTable.VW_TAB.NAME.X
    local iTy = iOx + RResourceTable.VW_TAB.NAME.Y
    if math.between(iPx, iTx, iTx + 4 * RResourceTable.VW_TAB.W) and math.between(iPy, iTy, iTy + RResourceTable.VW_TAB.H) then
        local iTab = math.floor((iPx - iTx) / RResourceTable.VW_TAB.W)

        local fn_update_tab = self:get_fn_update_tab()
        fn_update_tab(self, iTab)
    end
end

function CRscTableElem:onmousereleased(x, y, button)
    local iTabWidth = RResourceTable.VW_TAB.W
    local iTabHeight = RResourceTable.VW_TAB.H

    if button == 1 then
        self:_try_click_tab(x, y)
    end
end

function CRscTableElem:onwheelmoved(dx, dy)
    local iAdy = math.abs(dy)
    if iAdy >= LInput.MOUSE_WHEEL_MOVE_DY then
        local iDlt = -1 * (dy / iAdy)   -- increase on roll-down

        local iNextSlct = self:get_row_selected() + iDlt

        update_row_for_resource_table(self, iNextSlct)
        iNextSlct = self:get_row_selected()

        local m_pSlider = self.pSlider
        m_pSlider:set_current(iNextSlct)
    end
end
