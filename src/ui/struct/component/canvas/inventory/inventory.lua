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
require("ui.constant.style")
require("ui.run.draw.canvas.inventory.inventory")
require("ui.struct.component.basic.base")
require("utils.struct.class")

CCanvasInventory = createClass({
    eElem = CBasicElem:new(),

    pInvt,
    iSlctTab,
    iSlctRow,
    iNewIt,

    rgpVwItems = {}
})

function CCanvasInventory:get_origin()
    return self.eElem:get_pos()
end

function CCanvasInventory:get_tab_selected()
    return self.iSlctTab
end

function CCanvasInventory:get_row_selected()
    return self.iSlctRow
end

function CCanvasInventory:_set_row_selected(iRow)
    self.iSlctRow = iRow
end

function CCanvasInventory:fetch_item_range()
    local m_rgpVwItems = self.rgpVwItems

    local iRow = self:get_row_selected()
    local iSt = (iRow * 4) + 1
    local iEn = math.min(#m_rgpVwItems, (iRow + 6) * 4)

    return iSt, iEn
end

function CCanvasInventory:fetch_item_palette()
    local m_rgpVwItems = self.rgpVwItems

    local rgpItems = {}
    local iSt, iEn = self:fetch_item_range()
    for i = iSt, iEn, 1 do
        table.insert(rgpItems, m_rgpVwItems[i])
    end

    return rgpItems
end

function CCanvasInventory:_update_item_position()
    local m_rgpVwItems = self.rgpVwItems
    local iSt, iEn = self:fetch_item_range()

    local m_eElem = self.eElem
    local iPx, iPy = m_eElem:get_pos()

    local iIx, iIy
    for i = iSt, iEn, 1 do
        local iR = math.floor(i / 4)
        local iC = i % 4

        iIx = iPx + iC * RStylebox.VW_ITEM_INVT.W
        iIy = iPy + iR * RStylebox.VW_ITEM_INVT.H

        local pVwItem = m_rgpVwItems[i]
        pVwItem:update(iIx, iIy)
    end
end

function CCanvasInventory:update_row(iNextSlct)
    local m_pInvt = self.pInvt

    local iRow = math.iclamp(iNextSlct, 0, math.ceil(m_pInvt:get_size() / 4) - 6)
    self:_set_row_selected(iRow)
    self:_update_item_position(iRow)
end

function CCanvasInventory:load(pInvt, iPx, iPy)
    self.eElem:load(iPx, iPy)

    self.pInvt = pInvt
    self.iSlctTab = 1
    self.iNewIt = -1
    self.iSlctRow = 0

    local i = 0
    for iId, iCount in ipairs(pInvt:get_items()) do
        local pVwItem = CCanvasItem:new()
        pVwItem:load(iId, iCount)

        i = i + 1
    end
end

function CCanvasInventory:update(dt)
    -- todo rollbar
end

function CCanvasInventory:draw()
    draw_player_inventory(self)
end
