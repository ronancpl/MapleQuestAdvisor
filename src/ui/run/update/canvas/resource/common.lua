--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("ui.run.update.canvas.resource.entry")
require("ui.struct.window.element.basic.slider")

local function fetch_item_range(pVwRscs, pConfVw)
    local rgpVwItems = pVwRscs:get_view_items()

    local iRow = pVwRscs:get_row_selected() - 1
    local iSt = (iRow * pConfVw.COLS) + 1
    local iEn = math.min(#rgpVwItems, (iRow + pConfVw.ROWS) * pConfVw.COLS)

    return iSt, iEn
end

function fetch_item_palette_for_resource_table(pVwRscs)
    local rgpVwItems = pVwRscs:get_view_items()

    local rgpItems = {}
    local iSt, iEn = pVwRscs:get_view_range()
    for i = iSt, iEn, 1 do
        table.insert(rgpItems, rgpVwItems[i])
    end

    return rgpItems
end

local function clear_current_item_range(pVwRscs)
    local rgpVwItems = pVwRscs:get_view_items()
    local iSt, iEn = pVwRscs:get_view_range()

    for i = iSt, iEn, 1 do
        local pVwItem = rgpVwItems[i]
        if pVwItem ~= nil then
            pVwItem:update(-1, -1)
        end
    end
end

local function update_item_position(pVwRscs, pConfVw)
    local rgpVwItems = pVwRscs:get_view_items()

    local iSt, iEn = fetch_item_range(pVwRscs, pConfVw)
    clear_current_item_range(pVwRscs)

    pVwRscs:set_view_range(iSt, iEn)

    local iPx, iPy = pVwRscs:get_origin()

    iPx = iPx + pConfVw.X + pConfVw.ST_X
    iPy = iPy + pConfVw.Y + pConfVw.ST_Y

    local iIx, iIy

    local iPos = iSt - 1
    local iBr = math.floor(iPos / pConfVw.COLS)

    for i = iSt, iEn, 1 do
        local iPos = i - 1
        local iR = math.floor(iPos / pConfVw.COLS)
        local iC = iPos % pConfVw.COLS

        iIx = iPx + iC * (pConfVw.W + pConfVw.FIL_X)
        iIy = iPy + (iR - iBr) * (pConfVw.H + pConfVw.FIL_Y)

        local pVwItem = rgpVwItems[i]
        if pVwItem ~= nil then
            pVwItem:update(iIx, iIy)
        end
    end
end

function update_row_for_resource_table(pVwRscs, iNextSlct, pConfVw)
    local iInvtRows = math.ceil(pVwRscs:get_num_items() / pConfVw.ROWS)
    local iRow = math.iclamp(iNextSlct, 1, math.max(iInvtRows, 1))

    pVwRscs:set_row_selected(iRow)

    update_item_position(pVwRscs, pConfVw)
end

function update_tab_for_resource_table(pVwRscs, iNextTab)
    local rgpTabVwItems = pVwRscs:get_tab_items()

    local iTab = math.iclamp(iNextTab + 1, 1, #rgpTabVwItems)
    pVwRscs:set_tab_selected(iTab)

    local rgpVwItems = rgpTabVwItems[iTab]
    pVwRscs:update_view_items(rgpVwItems)

    local fn_update_row = pVwRscs:get_fn_update_row()
    fn_update_row(pVwRscs, 0)  -- set to list start
end

function update_resource_tabs(pVwRscs, pRscProp)
    update_resource_items(pVwRscs, pRscProp)
end

function update_items_for_resource_table(pVwRscs, pRscProp, pConfVw)
    pVwRscs:set_tab_selected(1)
    pVwRscs:set_row_selected(0)

    update_resource_tabs(pVwRscs, pRscProp)

    local rgpVwItems = pVwRscs:get_view_items()
    local iSgmts = math.ceil(#rgpVwItems / pConfVw.ROWS)

    local pSlider = pVwRscs:get_slider()
    pSlider:set_num_segments(iSgmts)

    local bDisable = iSgmts <= pConfVw.COLS
    if bDisable then
        pSlider:update_state(RSliderState.DISABLED)
    else
        pSlider:update_state(RSliderState.NORMAL)
    end
end
