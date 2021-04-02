--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("ui.constant.style")
require("ui.run.draw.canvas.inventory.item")

local function codify_inventory_tab_intervals(pVwInvt)
    local rgiIntvVals = {}

    local nIntvs = #ctVwInvt:get_tab_names() + 1
    for i = 1, nIntvs, 1 do
        table.insert(rgiIntvVals, 0)
    end

    local iSlctTab = pVwInvt:get_tab_selected()
    if iSlctTab <= 0 then
        rgiIntvVals[1] = 1
        rgiIntvVals[2] = 1
    elseif iSlctTab >= nIntvs - 1 then
        rgiIntvVals[nIntvs - 1] = 2
        rgiIntvVals[nIntvs] = 1
    else
        rgiIntvVals[iSlctTab] = 2
        rgiIntvVals[iSlctTab + 1] = 1
    end

    return rgiIntvVals
end

local function translate_inventory_tab_intervals(rgiIntvVals)
    local rgsIntvNames = {}
    local tiVals = {}

    local nIntvs = #rgiIntvVals
    for i = 1, nIntvs, 1 do
        rgsIntvNames[i] = "middle"
        tiVals[i] = rgiIntvVals[i]
    end
    rgsIntvNames[1] = "left"
    rgsIntvNames[nIntvs] = "right"

    local rgsIntvImgNames = {}
    for i = 1, nIntvs, 1 do
        local sName = rgsIntvNames[i]
        local iVal = tiVals[i]

        table.insert(rgsIntvImgNames, sName .. iVal)
    end

    return rgsIntvImgNames
end

local function draw_compose_fill(iFilVal, iX, iY, tpTabImgs, iTabWidth)
    local pImg = tpTabImgs["fill" .. iFilVal]

    local iFilWidth
    local iFilHeight
    iFilWidth, iFilHeight = pImg:getDimensions()

    love.graphics.setScissor(iX, iY, iTabWidth, iFilHeight)

    local iPx = iX
    local iPy = iY
    for i = 1, math.ceil(iTabWidth / iFilWidth), 1 do
        love.graphics.draw(pImg, iPx, iPy)
        iPx = iPx + iFilWidth
    end

    love.graphics.setScissor()

    return iPx, iPy
end

local function draw_compose_tab_part(iX, iY, pImg)
    local iPx = iX
    local iPy = iY

    local iW
    local iH
    iW, iH = pImg:getDimensions()

    love.graphics.draw(pImg, iPx, iPy)

    iPx = iPx + iW
    iPy = iPy + iH

    return iPx, iPy
end

local function calc_fill_value(iCurIdx, iSlctTab)
    return iCurIdx == iSlctTab and 1 or 0
end

local function draw_compose_inventory_tabs(pVwInvt, rgsIntvImgNames, iTabWidth)
    local tpTabImgs = ctVwInvt:get_tab_components()

    local rgpTabImgs = {}
    local rgiTabVals = {}
    for _, sIntvImgName in ipairs(rgsIntvImgNames) do
        local pImg = tpTabImgs[sIntvImgName]

        table.insert(rgpTabImgs, pImg)
        table.insert(rgiTabVals, tonumber(string.sub(sIntvImgName, -1, -1)) - 1)
    end

    local nIntvImgs = #rgpTabImgs

    local iPx
    local iPy
    iPx, iPy = pVwInvt:get_origin()

    local iSlctTab = pVwInvt:get_tab_selected() + 1

    if nIntvImgs > 0 then
        local iFilVal = calc_fill_value(1, iSlctTab)
        iPx, _ = draw_compose_fill(iFilVal, iPx, iPy, tpTabImgs, iTabWidth)
        iPx, _ = draw_compose_tab_part(iPx, iPy, rgpTabImgs[1])

        for i = 2, nIntvImgs - 1, 1 do
            local iFilVal = calc_fill_value(i, iSlctTab)
            iPx, _ = draw_compose_fill(iFilVal, iPx, iPy, tpTabImgs, iTabWidth)
            iPx, _ = draw_compose_tab_part(iPx, iPy, rgpTabImgs[i])
        end

        local iFilVal = calc_fill_value(nIntvImgs, iSlctTab)
        iPx, _ = draw_compose_fill(iFilVal, iPx, iPy, tpTabImgs, iTabWidth)
        iPx, _ = draw_compose_tab_part(iPx, iPy, rgpTabImgs[nIntvImgs])
    end
end

local function draw_compose_inventory_tab_names(pVwInvt, iTabWidth, iTabHeight)
    local iPx
    local iPy
    iPx, iPy = pVwInvt:get_origin()

    local rgpImgNames = ctVwInvt:get_tab_names()

    local nImgNames = #rgpImgNames
    if nImgNames > 0 then
        local iH
        _, iH = rgpImgNames[1]:getDimensions()

        local iOy = (iTabHeight - iH) / 2

        for i = 1, nImgNames, 1 do
            local pImgName = rgpImgNames[i]

            local iW
            iW, _ = pImgName:getDimensions()

            local iOx = (iTabWidth - iW) / 2
            love.graphics.draw(pImgName, iPx - iOx, iPy - iOy)

            iPx = iPx + iTabWidth
        end
    end
end

local function draw_inventory_tabs(pVwInvt)
    local rgiIntvVals = codify_inventory_tab_intervals(pVwInvt)
    local rgsIntvImgNames = translate_inventory_tab_intervals(rgiIntvVals)

    local iTabWidth = RStylebox.VW_ITEM_INVT_TAB.W
    local iTabHeight = RStylebox.VW_ITEM_INVT_TAB.H

    draw_compose_inventory_tabs(pVwInvt, rgsIntvImgNames, iTabWidth)
    draw_compose_inventory_tab_names(pVwInvt, iTabWidth, iTabHeight)
end

local function draw_compose_item_image(pVwItem, iItemWidth, iItemHeight)
    local iPx
    local iPy
    iPx, iPy = pVwItem:get_origin()

    local pImg = pVwItem:get_image()
    local bShowCount = pVwItem:is_visible_count()

    local iCount = bShowCount and pVwItem:get_count() or nil
    draw_item_canvas(pImg, iCount, iPx, iPy, iItemWidth, iItemHeight)
end

function draw_inventory_item(pVwItem)
    draw_compose_item_image(pVwItem, RStylebox.VW_ITEM_INVT.W, RStylebox.VW_ITEM_INVT.H)
end

local function draw_inventory_items(pVwInvt)
    for _, pVwItem in ipairs(pVwInvt:fetch_item_palette()) do
        pVwItem:draw()
    end
end

local function draw_inventory_background(pVwInvt)
    local pImg = ctVwInvt:get_background()

    local iPx
    local iPy
    iPx, iPy = pVwInvt:get_origin()

    love.graphics.draw(pImg, iPx, iPy)
end

function draw_player_inventory(pVwInvt)
    draw_inventory_background(pVwInvt)
    draw_inventory_tabs(pVwInvt)
    draw_inventory_items(pVwInvt)
end
