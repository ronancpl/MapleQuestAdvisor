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

CInvtElem = createClass({
    eElem = CBasicElem:new(),

    pInvt,
    iSlctTab,
    iSlctRow,
    iNewIt,

    rgpVwItems = {}
})

function CInvtElem:get_origin()
    return self.eElem:get_pos()
end

function CInvtElem:get_tab_selected()
    return self.iSlctTab
end

function CInvtElem:get_row_selected()
    return self.iSlctRow
end

function CInvtElem:_set_row_selected(iRow)
    self.iSlctRow = iRow
end

function CInvtElem:fetch_item_range()
    local m_rgpVwItems = self.rgpVwItems

    local iRow = self:get_row_selected()
    local iSt = (iRow * 4) + 1
    local iEn = math.min(#m_rgpVwItems, (iRow + 6) * 4)

    return iSt, iEn
end

function CInvtElem:fetch_item_palette()
    local m_rgpVwItems = self.rgpVwItems

    local rgpItems = {}
    local iSt, iEn = self:fetch_item_range()
    for i = iSt, iEn, 1 do
        table.insert(rgpItems, m_rgpVwItems[i])
    end

    return rgpItems
end

function CInvtElem:_update_item_position()
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

function CInvtElem:update_row(iNextSlct)
    local m_pInvt = self.pInvt

    local iRow = math.iclamp(iNextSlct, 0, math.ceil(m_pInvt:get_size() / 4) - 6)
    self:_set_row_selected(iRow)
    self:_update_item_position(iRow)
end

function CInvtElem:load(pInvt, iPx, iPy)
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

function CInvtElem:update(dt)
    -- do nothing
end

function CInvtElem:draw()
    draw_player_inventory(self)
end

function CInvtElem:onwheelmoved(dx, dy)
    local iDlt = dy / math.abs(dy)
    local iNextSlct = self:get_row_selected() + iDlt

    self:update_row(iNextSlct)
end
