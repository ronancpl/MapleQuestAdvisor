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
require("ui.constant.view.inventory")
require("ui.struct.component.canvas.inventory.item")
require("ui.struct.window.element.basic.slider")

local function fetch_item_range(pVwInvt)
    local rgpVwItems = pVwInvt:get_view_items()

    local iRow = pVwInvt:get_row_selected() - 1
    local iSt = (iRow * RInventory.VW_INVT.COLS) + 1
    local iEn = math.min(#rgpVwItems, (iRow + RInventory.VW_INVT.ROWS) * RInventory.VW_INVT.COLS)

    return iSt, iEn
end

function fetch_item_palette_for_inventory(pVwInvt)
    local rgpVwItems = pVwInvt:get_view_items()

    local rgpItems = {}
    local iSt, iEn = pVwInvt:get_view_range()
    for i = iSt, iEn, 1 do
        table.insert(rgpItems, rgpVwItems[i])
    end

    return rgpItems
end

local function clear_current_item_range(pVwInvt)
    local iSt, iEn = pVwInvt:get_view_range()
    if iSt <= iEn then
        local rgpVwItems = pVwInvt:get_view_items()
        local pLyr = pUiInvt:get_layer(LLayer.NAV_INVT_TABLE)

        for i = iSt, iEn, 1 do
            local pVwItem = rgpVwItems[i]
            if pVwItem ~= nil then
                pLyr:remove_element(LChannel.INVT_ITEM, pVwItem)
                pVwItem:update_position(-1, -1)
            end
        end
    end
end

local function update_item_position(pVwInvt)
    local iSt, iEn = fetch_item_range(pVwInvt)
    if iSt <= iEn then
        clear_current_item_range(pVwInvt)
        pVwInvt:set_view_range(iSt, iEn)

        local rgpVwItems = pVwInvt:get_view_items()

        local iPx, iPy = pVwInvt:get_origin()

        iPx = iPx + RInventory.VW_INVT_ITEM.X + RInventory.VW_INVT_ITEM.ST_X
        iPy = iPy + RInventory.VW_INVT_ITEM.Y + RInventory.VW_INVT_ITEM.ST_Y

        local iIx, iIy

        local iPos = iSt - 1
        local iBr = math.floor(iPos / RInventory.VW_INVT.COLS)

        local pLyr = pUiInvt:get_layer(LLayer.NAV_INVT_TABLE)

        for i = iSt, iEn, 1 do
            local iPos = i - 1
            local iR = math.floor(iPos / RInventory.VW_INVT.COLS)
            local iC = iPos % RInventory.VW_INVT.COLS

            iIx = iPx + iC * (RInventory.VW_INVT_ITEM.W + RInventory.VW_INVT_ITEM.FIL_X)
            iIy = iPy + (iR - iBr) * (RInventory.VW_INVT_ITEM.H + RInventory.VW_INVT_ITEM.FIL_Y)

            local pVwItem = rgpVwItems[i]
            if pVwItem ~= nil then
                pLyr:add_element(LChannel.INVT_ITEM, pVwItem)
                pVwItem:update_position(iIx, iIy)
            end
        end
    end
end

local function update_inventory_slider(pVwInvt, bMoveTop)
    local rgpVwItems = pVwInvt:get_view_items()

    local iSgmts = math.ceil(#rgpVwItems / RInventory.VW_INVT.COLS)
    iSgmts = math.max(iSgmts - RInventory.VW_INVT.ROWS, 0) + 1

    local pSlider = pVwInvt:get_slider()
    pSlider:set_num_segments(iSgmts)

    if bMoveTop then
        pSlider:set_wheel_segment(0)
    end

    local bDisable = iSgmts < 2
    if bDisable then
        pSlider:update_state(RSliderState.DISABLED)
    else
        pSlider:update_state(RSliderState.NORMAL)
    end
end

function update_row_for_inventory(pVwInvt, iNextSlct)
    local iRow = math.iclamp(iNextSlct, 1, math.max(pVwInvt:get_slider():get_num_segments(), 1))
    pVwInvt:set_row_selected(iRow)

    update_item_position(pVwInvt)
end

function update_tab_for_inventory(pVwInvt, iNextTab)
    clear_current_item_range(pVwInvt)

    local rgpTabVwItems = pVwInvt:get_tab_items()
    local iTab = math.iclamp(iNextTab + 1, 1, #rgpTabVwItems)
    pVwInvt:set_tab_selected(iTab)

    pVwInvt:refresh_view_items()

    update_row_for_inventory(pVwInvt, 1)  -- set to list start

    update_inventory_slider(pVwInvt, true)
end

local function update_inventory_tabs(pVwInvt, pInvt)
    local tpVwItems = {}
    for iId, iCount in pairs(pInvt:get_items()) do
        local siType = math.iclamp(math.floor(iId / 1000000), 1, 5)

        local pVwItem = CInvtElemItem:new()
        pVwItem:load(iId, iCount)

        local rgpVwItems = create_inner_table_if_not_exists(tpVwItems, siType)
        table.insert(rgpVwItems, pVwItem)
    end

    pVwInvt:clear_tab_items()
    for siType, rgpVwItems in pairs(tpVwItems) do
        pVwInvt:add_tab_items(siType, rgpVwItems)
    end
end

function update_items_for_inventory(pVwInvt, pInvt)
    pVwInvt:set_tab_selected(1)
    pVwInvt:set_row_selected(1)

    update_inventory_tabs(pVwInvt, pInvt)
    update_tab_for_inventory(pVwInvt, 0)  -- set to EQUIP
end
