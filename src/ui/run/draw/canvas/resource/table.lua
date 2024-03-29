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
require("ui.run.update.canvas.resource.common")
require("ui.struct.toolkit.graphics")

local function codify_resources_tab_intervals(pVwRscs)
    local rgiIntvVals = {}

    local nIntvs = #ctVwRscs:get_tab_names() + 1
    for i = 1, nIntvs, 1 do
        table.insert(rgiIntvVals, 0)
    end

    local iSlctTab = pVwRscs:get_tab_selected()
    if iSlctTab <= 1 then
        rgiIntvVals[1] = 1
        rgiIntvVals[2] = 1
    elseif iSlctTab >= nIntvs then
        rgiIntvVals[nIntvs - 1] = 2
        rgiIntvVals[nIntvs] = 1
    else
        rgiIntvVals[iSlctTab] = 2
        rgiIntvVals[iSlctTab + 1] = 1
    end

    return rgiIntvVals
end

local function translate_resources_tab_intervals(rgiIntvVals)
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

local function draw_compose_fill(iFilVal, iX, iY, tpTabImgs, iTabWidth, rgiTabWidths, iImgIdx)
    local pImg = tpTabImgs["fill" .. iFilVal]

    local iFilImgWidth
    local iFilImgHeight
    iFilImgWidth, iFilImgHeight = pImg:getDimensions()

    local iWidthT1 = iImgIdx == #rgiTabWidths and rgiTabWidths[iImgIdx - 1] or 0
    local iWidthT2 = rgiTabWidths[iImgIdx]
    local iFilWidth = iTabWidth - iWidthT1 - iWidthT2

    graphics_set_scissor(iX, iY, iFilWidth, iFilImgHeight)

    local iPx = iX
    local iPy = iY
    for i = 1, math.ceil(iFilWidth / iFilImgWidth), 1 do
        graphics_draw(pImg, iPx, iPy)
        iPx = iPx + iFilImgWidth
    end

    graphics_set_scissor()

    return iPx, iPy
end

local function draw_compose_tab_part(iX, iY, pImg)
    local iPx = iX
    local iPy = iY

    local iW
    local iH
    iW, iH = pImg:getDimensions()

    graphics_draw(pImg, iPx, iPy)

    iPx = iPx + iW
    iPy = iPy + iH

    return iPx, iPy
end

local function calc_fill_value(iCurIdx, iSlctTab)
    return iCurIdx - 1 == iSlctTab and 1 or 0
end

local function draw_compose_resource_tabs(pVwRscs, rgsIntvImgNames, iTabWidth)
    local tpTabImgs = ctVwRscs:get_tab_components()

    local rgpTabImgs = {}
    local rgiTabWidths = {}
    local rgiTabVals = {}
    for _, sIntvImgName in ipairs(rgsIntvImgNames) do
        local pImg = tpTabImgs[sIntvImgName]
        local iImgWidth = pImg:getWidth()

        table.insert(rgpTabImgs, pImg)
        table.insert(rgiTabWidths, iImgWidth)
        table.insert(rgiTabVals, tonumber(string.sub(sIntvImgName, -1, -1)) - 1)
    end

    local nIntvImgs = #rgpTabImgs

    local iPx
    local iPy
    iPx, iPy = 0, 0

    iPx = iPx + RResourceTable.VW_TAB.NAME.X
    iPy = iPy + RResourceTable.VW_TAB.NAME.Y

    local iSlctTab = pVwRscs:get_tab_selected()
    if nIntvImgs > 0 then
        local iFilVal = calc_fill_value(1, iSlctTab)
        --iPx, _ = draw_compose_fill(iFilVal, iPx, iPy, tpTabImgs, iTabWidth, rgiTabWidths, 1)
        iPx, _ = draw_compose_tab_part(iPx, iPy, rgpTabImgs[1])

        for i = 2, nIntvImgs - 1, 1 do
            local iFilVal = calc_fill_value(i, iSlctTab)
            iPx, _ = draw_compose_fill(iFilVal, iPx, iPy, tpTabImgs, iTabWidth, rgiTabWidths, i)
            iPx, _ = draw_compose_tab_part(iPx, iPy, rgpTabImgs[i])
        end

        local iFilVal = calc_fill_value(nIntvImgs, iSlctTab)
        iPx, _ = draw_compose_fill(iFilVal, iPx, iPy, tpTabImgs, iTabWidth, rgiTabWidths, nIntvImgs)
        iPx, _ = draw_compose_tab_part(iPx, iPy, rgpTabImgs[nIntvImgs])
    end
end

local function draw_compose_resource_tab_names(pVwRscs, iTabWidth, iTabHeight)
    local iPx
    local iPy
    iPx, iPy = 0, 0

    iPx = iPx + RResourceTable.VW_TAB.NAME.X
    iPy = iPy + RResourceTable.VW_TAB.NAME.Y + 1

    local rgpTxtTabs = ctVwRscs:get_tab_names()

    local nTabs = #rgpTxtTabs
    if nTabs > 0 then
        local iH = rgpTxtTabs[1]:getHeight()

        local iOy = math.floor((iTabHeight - iH) / 2)

        for i = 1, nTabs, 1 do
            local pTxtName = rgpTxtTabs[i]

            local iW = pTxtName:getWidth()

            local iOx = math.floor((iTabWidth - iW) / 2)
            graphics_draw(pTxtName, iPx + iOx, iPy + iOy)

            iPx = iPx + iTabWidth
        end
    end
end

local function draw_resource_reward_tab_name(pVwRscs, iTabWidth, iTabHeight)
    local iPx
    local iPy
    iPx, iPy = 0, 0

    iPx = iPx + RResourceTable.VW_TAB.NAME.X
    iPy = iPy + RResourceTable.VW_TAB.NAME.Y + 1

    iPx = iPx + (4 * iTabWidth)

    local pImgRwdIcon = ctVwRscs:get_reward_icon()

    local iW = iTabWidth - 5
    local iH = math.floor((iW / pImgRwdIcon:getWidth()) * pImgRwdIcon:getHeight())

    local iOx = math.floor((iTabWidth - iW) / 2)
    local iOy = math.floor((iTabHeight - iH) / 2)

    graphics_draw(pImgRwdIcon, iPx + iOx, iPy + iOy, 0, iW)
end

local function draw_resource_tabs(pVwRscs)
    local rgiIntvVals = codify_resources_tab_intervals(pVwRscs)
    local rgsIntvImgNames = translate_resources_tab_intervals(rgiIntvVals)

    local iTabWidth = RResourceTable.VW_TAB.W
    local iTabHeight = RResourceTable.VW_TAB.H

    draw_compose_resource_tabs(pVwRscs, rgsIntvImgNames, iTabWidth)
    draw_compose_resource_tab_names(pVwRscs, iTabWidth, iTabHeight)

    draw_resource_reward_tab_name(pVwRscs, iTabWidth, iTabHeight)
end

local function draw_resource_field_base_box(pVwRscs, iPx, iPy)
    local eTexture = pVwRscs:get_background_field()

    local iFx = RResourceTable.VW_WND.VW_FIELD.FIL_X
    local iFy = RResourceTable.VW_WND.VW_FIELD.FIL_Y

    eTexture:draw(iPx - iFx, iPy - iFy)
end

local function draw_resource_field_base_text(pVwRscs, iPx, iPy)
    local pImgBase = ctVwRscs:get_background_text()
    graphics_draw(pImgBase, iPx, iPy)
end

local function draw_resource_field_base(pVwRscs)
    local iPx
    local iPy
    iPx, iPy = 0, 0

    local pConfVw = pVwRscs:get_conf()
    iPx = iPx + pConfVw.X
    iPy = iPy + pConfVw.Y

    draw_resource_field_base_box(pVwRscs, iPx, iPy)
    draw_resource_field_base_text(pVwRscs, iPx, iPy)
end

local function draw_resource_background(pVwRscs)
    local eTexture = pVwRscs:get_background()

    local iPx
    local iPy
    iPx, iPy = 0, 0

    eTexture:draw(iPx, iPy)

    draw_resource_field_base(pVwRscs)
end

local function draw_resource_slider(pVwRscs)
    local iPx
    local iPy
    iPx, iPy = 0, 0

    pVwRscs:get_slider():draw(iPx, iPy)
end

function draw_table_resources(pVwRscs)
    draw_resource_background(pVwRscs)
    draw_resource_tabs(pVwRscs)
    draw_resource_field_base(pVwRscs)
    draw_resource_slider(pVwRscs)

    if pVwRscs:get_tab_selected() == RResourceTable.TAB.REWARD.ID then
        pVwRscs:get_reward_tab():draw()
    end
end
