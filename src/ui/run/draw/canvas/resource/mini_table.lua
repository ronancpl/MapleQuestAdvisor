--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

local bit = require("bit")

require("router.procedures.constant")
require("ui.constant.view.resource")
require("ui.run.update.canvas.position")
require("ui.struct.component.element.texture")
require("ui.struct.window.summary")

local function fn_get_items(pVwRscs)
    return pVwRscs:get_tab_item(RResourceTable.TAB.ITEMS.ID)
end

local function fn_get_mobs(pVwRscs)
    return pVwRscs:get_tab_item(RResourceTable.TAB.MOBS.ID)
end

local function fn_get_npcs(pVwRscs)
    return pVwRscs:get_tab_item(RResourceTable.TAB.NPC.ID)
end

local function fn_get_fields(pVwRscs)
    return pVwRscs:get_tab_item(RResourceTable.TAB.FIELD_ENTER.ID)
end

local function is_tab_required(pRscEntry)
    return pRscEntry ~= nil and #pRscEntry > 0
end

local function fetch_minitable_headers(pVwRscs)
    local pTableConfVw = RResourceTable.VW_GRID_MINI
    local rgpTableTabConfVw = {pTableConfVw.ITEMS, pTableConfVw.MOBS, pTableConfVw.NPCS, pTableConfVw.FIELD_ENTER}
    local rgfn_get_entry_rsc = {fn_get_items, fn_get_mobs, fn_get_npcs, fn_get_fields}

    local rgpTabConfVw = {}
    local rgpTabsVw = {}

    for i = 1, #rgpTableTabConfVw, 1 do
        local fn_get_entry = rgfn_get_entry_rsc[i]

        local pTabVw = fn_get_entry(pVwRscs)
        if is_tab_required(pTabVw) then
            local pTabConfVw = rgpTableTabConfVw[i]

            table.insert(rgpTabConfVw, pTabConfVw)
            table.insert(rgpTabsVw, pTabVw)
        else
            table.insert(rgpTabConfVw, {})
            table.insert(rgpTabsVw, {})
        end
    end

    return pTableConfVw, rgpTabConfVw, rgpTabsVw
end

local function has_tab_items(pTabConfVw)
    if pTabConfVw ~= nil then
        for _, _ in pairs(pTabConfVw) do
            return true
        end
    end

    return false
end

local function get_count_tabs(rgpTabConfVw)
    local iCount = 0

    for _, pTabConfVw in ipairs(rgpTabConfVw) do
        if has_tab_items(pTabConfVw) then
            iCount = iCount + 1
        end
    end

    return iCount
end

local function is_tab_shifted(rgpTabConfVw)
    local iIdx = 0

    for _, pTabConfVw in ipairs(rgpTabConfVw) do
        iIdx = iIdx + 1

        if has_tab_items(pTabConfVw) then
            break
        end
    end

    return iIdx >= 3 and get_count_tabs(rgpTabConfVw) < 3
end

local function fetch_tab_position(pTableConfVw, rgpTabConfVw, siTabIdx)
    if rgpTabConfVw ~= nil then
        local iCount = get_count_tabs(rgpTabConfVw)
        if iCount < 2 then
            if not has_tab_items(rgpTabConfVw[3]) or siTabIdx % 2 == 1 then siTabIdx = 3
            elseif not has_tab_items(rgpTabConfVw[4]) or siTabIdx % 2 == 0 then siTabIdx = 4
            end
        elseif iCount < 3 then       -- head start at half table
            if siTabIdx == 2 and not has_tab_items(rgpTabConfVw[1]) and has_tab_items(rgpTabConfVw[2]) then
                siTabIdx = 1
            end

            siTabIdx = siTabIdx + 2
        end
    end

    local iW2 = math.ceil(pTableConfVw.W / 2)
    local iH2 = math.ceil(pTableConfVw.H / 2)

    local btTab = bit.tobit(siTabIdx - 1)

    local iTx = bit.band(btTab, bit.lshift(1, 1)) == 0 and iW2 or 0
    local iTy = bit.band(btTab, bit.lshift(1, 0)) == 0 and 0 or iH2

    return iTx, iTy
end

function load_minitable_tab_background(pVwRscs)
    local pTextureData = ctVwRscs:get_background_data()
    local pImgBox, iIx, iIy, iIw, iIh, iOx, iOy, iOw, iOh = pTextureData:get()

    local pTableConfVw, rgpTabConfVw
    pTableConfVw, rgpTabConfVw, _ = fetch_minitable_headers(pVwRscs)

    local rgeTextures = {}
    for i = 1, 4, 1 do
        if has_tab_items(rgpTabConfVw[i]) then
            local siIdx = i
            if is_tab_shifted(rgpTabConfVw) then
                siIdx = siIdx - 2
            end
            local iTx, iTy = fetch_tab_position(pTableConfVw, rgpTabConfVw, siIdx)

            local eTexture = CTextureElem:new()
            eTexture:load(iTx, iTy, pImgBox, iIx, iIy, iIw, iIh, iOx, iOy, iOw, iOh)

            local pConfVw = RResourceTable.VW_GRID_MINI
            local iW2 = math.ceil(pConfVw.W / 2)
            local iH2 = math.ceil(pConfVw.H / 2)
            eTexture:build(iW2, iH2)

            table.insert(rgeTextures, eTexture)
        end
    end

    pVwRscs:set_background_tabs(rgeTextures)
end

function fetch_table_dimensions(pVwRscs)
    local pTableConfVw
    local rgpTabConfVw
    pTableConfVw, rgpTabConfVw, _ = fetch_minitable_headers(pVwRscs)

    local i = #rgpTabConfVw
    for j = i, 1, -1 do
        if has_tab_items(rgpTabConfVw[j]) then
            i = j
            break
        elseif j == 1 then
            i = 0
        end
    end

    local nTabs = i
    if nTabs > 0 then
        local iCount = get_count_tabs(rgpTabConfVw)

        local iW2 = math.ceil(pTableConfVw.W / 2)
        local iH2 = math.ceil(pTableConfVw.H / 2)

        if nTabs > 2 and not has_tab_items(rgpTabConfVw[1]) and not has_tab_items(rgpTabConfVw[2]) then
            nTabs = nTabs - 2
        elseif iCount == 1 then
            nTabs = 1
        end

        local iTx, iTy = fetch_tab_position(pTableConfVw, nil, nTabs)
        return pTableConfVw.W - iTx, (math.ceil(iCount / 2) * iH2) + iTy
    else
        return 0, 0
    end
end

local function fetch_tab_item_position(pTableConfVw, rgpTabConfVw, siTabIdx)
    local pConfVw = rgpTabConfVw[siTabIdx]

    local iPx = 0
    local iPy = 0

    local siIdx = siTabIdx
    local iTx, iTy = fetch_tab_position(pTableConfVw, rgpTabConfVw, siIdx)

    iPx = iPx + iTx
    iPy = iPy + iTy

    iPx = iPx + pConfVw.ST_X
    iPy = iPy + pConfVw.ST_Y

    return iPx, iPy
end

local function reset_item_position(pVwRscs)
    local rgpTabsVw = pVwRscs:get_tab_items()

    for _, pVwTab in ipairs(rgpTabsVw) do
        for _, pVwItem in ipairs(pVwTab) do
            pVwItem:update_position(U_INT_MIN, U_INT_MIN)
        end
    end
end

local function update_item_position(pVwRscs, siTabIdx, rgpTabConfVw, rgpTabsVw, pTableConfVw)
    local rgpVwItems = rgpTabsVw[siTabIdx]

    local pConfVw = rgpTabConfVw[siTabIdx]

    local iPx, iPy = fetch_tab_item_position(pTableConfVw, rgpTabConfVw, siTabIdx)

    local iSt = 1
    local iEn = math.min(#rgpVwItems, pConfVw.COLS * pConfVw.ROWS)
    for i = iSt, iEn, 1 do
        local iPos = i - 1
        local iR = math.floor(iPos / pConfVw.COLS)
        local iC = iPos % pConfVw.COLS

        local iIx = iPx + iC * (pConfVw.W + pConfVw.FIL_X)
        local iIy = iPy + iR * (pConfVw.H + pConfVw.FIL_Y)

        local pVwItem = rgpVwItems[i]
        if pVwItem ~= nil then
            pVwItem:update_position(iIx, iIy)
        end
    end
end

function load_minitable_resources(pVwRscs)
    reset_item_position(pVwRscs)

    local pTableConfVw
    local rgpTabConfVw
    local rgpTabsVw
    pTableConfVw, rgpTabConfVw, rgpTabsVw = fetch_minitable_headers(pVwRscs)

    for i = 1, #rgpTabConfVw, 1 do
        if has_tab_items(rgpTabConfVw[i]) then
            update_item_position(pVwRscs, i, rgpTabConfVw, rgpTabsVw, pTableConfVw)
        end
    end
end

local function draw_minitable_background(pVwRscs)
    local rgeTextures = pVwRscs:get_background_tabs()

    local rgpTabConfVw
    _, rgpTabConfVw, _ = fetch_minitable_headers(pVwRscs)
    for i = 1, #rgpTabConfVw, 1 do
        local eTexture = rgeTextures[i]
        if eTexture ~= nil then
            local iOx, iOy, _, _ = eTexture:get_ltrb()
            eTexture:draw(iOx, iOy)
        end
    end
end

local function draw_minitable_items(pVwRscs)
    local rgpTabsVw = pVwRscs:get_tab_items()

    for _, pVwTab in ipairs(rgpTabsVw) do
        for _, pVwItem in ipairs(pVwTab) do
            pVwItem:draw()
        end
    end
end

function draw_minitable_resources(pVwRscs)
    local iRx, iRy = pVwRscs:get_origin()
    push_stack_canvas_position(iRx, iRy)

    draw_minitable_background(pVwRscs)
    draw_minitable_items(pVwRscs)

    pop_stack_canvas_position()
end
