--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

local function fetch_outer_split(pImgBox)
    local iWidth
    local iHeight
    iWidth, iHeight = pImgBox:getDimensions()

    local rgpBoxOuter = { {0, 0}, {iWidth, 0}, {iWidth, iHeight}, {0, iHeight} }
    return rgpBoxOuter
end

local function fetch_inner_split(iL, iT, iR, iB)
    local rgpBoxInner = { {iL, iT}, {iR, iT}, {iR, iB}, {iL, iB} }
    return rgpBoxInner
end

local function decomp_img_quad(iSu, iSv, iTu, iTv, bVert)
    local iSx, iSy, iTx, iTy

    if not bVert then
        iSx = iSu
        iSy = iSv
        iTx = iTu
        iTy = iTv
    else
        iSy = iSu
        iSx = iSv
        iTy = iTu
        iTx = iTv
    end

    local iMinX
    local iMaxX
    if iSx < iTx then
        iMinX = iSx
        iMaxX = iTx
    else
        iMinX = iTx
        iMaxX = iSx
    end

    local iMinY
    local iMaxY
    if iSy < iTy then
        iMinY = iSy
        iMaxY = iTy
    else
        iMinY = iTy
        iMaxY = iSy
    end

    return {iMinX, iMaxX - iMinX, iMinY, iMaxY - iMinY}
end

local function decomp_img_segment(iStU, iStV, iMidStU, iMidStV, iMidEnU, iMidEnV, iEnU, iEnV, bVert)
    local rgpPos = {}

    table.insert(rgpPos, decomp_img_quad(iStU, iStV, iMidStU, iMidStV, bVert))
    table.insert(rgpPos, decomp_img_quad(iMidStU, iStV, iMidEnU, iMidEnV, bVert))
    table.insert(rgpPos, decomp_img_quad(iMidEnU, iStV, iEnU, iMidEnV, bVert))

    return rgpPos
end

local function fetch_decomp_img_section(iOx, iOy, iOxExt, iOyExt, iIx, iIy, iIxExt, iIyExt, bVert)
    -- decomposes in 3 quads, vertically (L, M, R) or horizontally (T, M, B)

    local iStU, iStV, iMidStU, iMidStV, iMidEnU, iMidEnV, iEnU, iEnV

    local iOu, iOv, iIu, iIv
    local iOuExt, iOvExt, iIuExt, iIvExt
    if not bVert then
        iOu = iOx
        iOv = iOy
        iIu = iIx
        iIv = iIy

        iIuExt = iIxExt
        iIvExt = iIyExt
        iOuExt = iOxExt
        iOvExt = iOyExt
    else
        iOu = iOy
        iOv = iOx
        iIu = iIy
        iIv = iIx

        iIuExt = iIyExt
        iIvExt = iIxExt
        iOuExt = iOyExt
        iOvExt = iOxExt
    end

    iStU = iOu
    iStV = iOv

    iMidStU = iIu
    iMidStV = iIv

    iMidEnU = iIu + iIuExt
    iMidEnV = iIv + iIvExt

    iEnU = iOu + iOuExt
    iEnV = iOv + iOvExt

    local rgpPos = decomp_img_segment(iStU, iStV, iMidStU, iMidStV, iMidEnU, iMidEnV, iEnU, iEnV, bVert)

    return rgpPos
end

local function fetch_box_section_measures(pBoxOuter1, pBoxInner1, pBoxOuter2, pBoxInner2)
    local iO1x, iO1y = unpack(pBoxOuter1)
    local iI1x, iI1y = unpack(pBoxInner1)

    local iO2x, iO2y = unpack(pBoxOuter2)
    local iI2x, iI2y = unpack(pBoxInner2)

    local iOx = iO1x
    local iOy = iO1y
    local iOxExt = iO2x - iO1x
    local iOyExt = iO2y - iO1y

    local iIx = iI1x
    local iIy = iI1y
    local iIxExt = iI2x - iI1x
    local iIyExt = iI2y - iI1y

    local bVert = iI1x == iI2x

    return iOx, iOy, iOxExt, iOyExt, iIx, iIy, iIxExt, iIyExt, bVert
end

local function decompose_box_image_parts(pImgBox, rgpBoxOuter, rgpBoxInner)
    local rgpBoxPos = {}

    -- quad corners
    for i = 1, #rgpBoxOuter, 1 do
        local pBoxOuter1 = rgpBoxOuter[i]
        local pBoxInner1 = rgpBoxInner[i]
        local pBoxOuter2 = rgpBoxOuter[(i % 4) + 1]
        local pBoxInner2 = rgpBoxInner[(i % 4) + 1]

        local iOx, iOy, iOxExt, iOyExt, iIx, iIy, iIxExt, iIyExt, bVert = fetch_box_section_measures(pBoxOuter1, pBoxInner1, pBoxOuter2, pBoxInner2)
        local rgpPos = fetch_decomp_img_section(iOx, iOy, iOxExt, iOyExt, iIx, iIy, iIxExt, iIyExt, bVert)

        for j = 1, 2, 1 do  -- skip #3, redundant
            table.insert(rgpBoxPos, rgpPos[j])
        end
    end

    -- quad middle
    table.insert(rgpBoxPos, {rgpBoxInner[1][1], rgpBoxInner[3][1] - rgpBoxInner[1][1], rgpBoxInner[1][2], rgpBoxInner[3][2] - rgpBoxInner[1][2]})

    return rgpBoxPos
end

local function decompose_box_image(pImgBox, rgpBoxOuter, rgpBoxInner)
    -- rgpBox Coords:
    -- top-left, top-right, bottom-right, bottom-left

    -- boxParts:
    -- Top-left, top, Top-right, Right, Bottom-right, Bottom, Bottom-left, Left, Mid

    local rgpBoxPos = decompose_box_image_parts(pImgBox, rgpBoxOuter, rgpBoxInner)
    return rgpBoxPos
end

-- boxParts:
-- Top-left, top, Top-right, Right, Bottom-right, Bottom, Bottom-left, Left
local tBoxPos = {LT = 1, T = 2, RT = 3, R = 4, RB = 5, B = 6, LB = 7, L = 8, M = 9}

function load_texture_split(pImgBox, iL, iT, iR, iB)
    local rgpBoxOuter = fetch_outer_split(pImgBox)
    local rgpBoxInner = fetch_inner_split(iL, iT, iR, iB)

    local rgpBoxPos = decompose_box_image(pImgBox, rgpBoxOuter, rgpBoxInner)
    return rgpBoxPos
end

local function get_pos_width(pPos)
    return pPos[2]
end

local function get_pos_height(pPos)
    return pPos[4]
end

local function get_quad_width(pQuad)
    local w
    _, _, w, _ = pQuad:getViewport()

    return w
end

local function get_quad_height(pQuad)
    local h
    _, _, _, h = pQuad:getViewport()

    return h
end

local function fetch_box_image_quads(pImgBox, rgpQuadPos)
    local rgpBoxQuads = {}

    local iBoxWidth
    local iBoxHeight
    iBoxWidth, iBoxHeight = pImgBox:getDimensions()

    for _, pPos in ipairs(rgpQuadPos) do
        local iLx, iW, iTy, iH = unpack(pPos)

        local pQuad = love.graphics.newQuad(iLx, iTy, iW, iH, iBoxWidth, iBoxHeight)
        table.insert(rgpBoxQuads, pQuad)
    end

    return rgpBoxQuads
end

-- {LT = 1, T = 2, RT = 3, R = 4, RB = 5, B = 6, LB = 7, L = 8, M = 9}

local function calc_element_dimensions(pPos, fLoopX, fLoopY, bExpandHz, bExpandVt)
    local iLx, iW, iTy, iH = unpack(pPos)
    iW = bExpandHz and iW * fLoopX or iW
    iH = bExpandVt and iH * fLoopY or iH

    return {iLx, iW, iTy, iH}
end

local function calc_texture_dimensions(rgpBoxPos, iWidth, iHeight)
    -- Diagonals do not repeat, remove fill

    local iExtX = iWidth - (get_pos_width(rgpBoxPos[tBoxPos.LT]) + get_pos_width(rgpBoxPos[tBoxPos.RT]))
    local iExtY = iHeight - (get_pos_height(rgpBoxPos[tBoxPos.LT]) + get_pos_height(rgpBoxPos[tBoxPos.LB]))

    local fLoopX = iExtX / get_pos_width(rgpBoxPos[tBoxPos.T])
    local fLoopY = iExtY / get_pos_height(rgpBoxPos[tBoxPos.L])

    return fLoopX, fLoopY
end

local function calc_pattern_box(rgpBoxPos, iWidth, iHeight)
    local fLoopX
    local fLoopY
    fLoopX, fLoopY = calc_texture_dimensions(rgpBoxPos, iWidth, iHeight)

    local rgpQuadPos = {}

    rgpQuadPos[tBoxPos.LT] = rgpBoxPos[tBoxPos.LT]
    rgpQuadPos[tBoxPos.T] = rgpBoxPos[tBoxPos.T]
    rgpQuadPos[tBoxPos.RT] = rgpBoxPos[tBoxPos.RT]
    rgpQuadPos[tBoxPos.R] = rgpBoxPos[tBoxPos.R]
    rgpQuadPos[tBoxPos.RB] = rgpBoxPos[tBoxPos.RB]
    rgpQuadPos[tBoxPos.B] = rgpBoxPos[tBoxPos.B]
    rgpQuadPos[tBoxPos.LB] = rgpBoxPos[tBoxPos.LB]
    rgpQuadPos[tBoxPos.L] = rgpBoxPos[tBoxPos.L]
    rgpQuadPos[tBoxPos.M] = rgpBoxPos[tBoxPos.M]

    return rgpQuadPos, {fLoopX, fLoopY}
end

function build_pattern_box(pImgBox, rgpBoxPos, iWidth, iHeight)
    local rgpQuadPos, pGrowth = calc_pattern_box(rgpBoxPos, iWidth, iHeight)
    local rgpBoxQuads = fetch_box_image_quads(pImgBox, rgpQuadPos)

    return rgpBoxQuads, pGrowth
end

local function fetch_next_pattern_hpos(pQuad, iPx)
    local iNextPx = iPx + get_quad_width(pQuad)
    return iNextPx
end

local function fetch_next_pattern_vpos(pQuad, iPy)
    local iNextPy = iPy + get_quad_height(pQuad)
    return iNextPy
end

local function draw_pattern_box_element(pImgBox, pQuad, iPx, iPy)
    love.graphics.draw(pImgBox, pQuad, iPx, iPy)
    return fetch_next_pattern_hpos(pQuad, iPx)
end

local function draw_pattern_box_mid(pImgBox, rgpBoxQuads, rgpQuadFitPos, iLoopX, iLoopY, iBx, iBy, iBoxMidWidth, iBoxMidHeight)
    local pQuad = rgpBoxQuads[tBoxPos.M]
    local pPos = rgpQuadFitPos[tBoxPos.M]

    local iX = pPos[1]
    local iY = pPos[3]

    local iPx = iX
    local iPy = iY

    local iWidthRT = get_quad_width(rgpBoxQuads[tBoxPos.RT])
    local iHeightLB = get_quad_height(rgpBoxQuads[tBoxPos.LB])

    love.graphics.setScissor(iBx, iBy, math.ceil(iWidthRT + iBoxMidWidth), math.ceil(iHeightLB + iBoxMidHeight - 7))

    for j = 1, iLoopY, 1 do
        for i = 1, iLoopX, 1 do
            iPx = draw_pattern_box_element(pImgBox, pQuad, iPx, iPy)
        end

        iPx = iX
        iPy = fetch_next_pattern_vpos(pQuad, iPy)
    end
end

local function draw_pattern_box_side(pImgBox, rgpBoxQuads, rgpQuadFitPos, iLoopX, iLoopY, iBx, iBy, iBoxMidWidth, iBoxMidHeight, iBoxWidth, iBoxHeight)
    local iWidthRT = get_quad_width(rgpBoxQuads[tBoxPos.RT])
    local iHeightLB = get_quad_height(rgpBoxQuads[tBoxPos.LB])

    love.graphics.setScissor(iBx, iBy, math.ceil(iWidthRT + iBoxMidWidth), math.ceil(iHeightLB + iBoxHeight))

    for _, sBoxPos in ipairs({tBoxPos.T, tBoxPos.B}) do
        local pQuad = rgpBoxQuads[sBoxPos]
        local pPos = rgpQuadFitPos[sBoxPos]

        local iX = pPos[1]
        local iY = pPos[3]

        local iPx = iX
        local iPy = iY

        for i = 1, iLoopX, 1 do
            iPx = draw_pattern_box_element(pImgBox, pQuad, iPx, iPy)
        end
    end

    love.graphics.setScissor(iBx, iBy, math.ceil(iWidthRT + iBoxWidth), math.ceil(iHeightLB + iBoxMidHeight))
    for _, sBoxPos in ipairs({tBoxPos.L, tBoxPos.R}) do
        local pQuad = rgpBoxQuads[sBoxPos]
        local pPos = rgpQuadFitPos[sBoxPos]

        local iX = pPos[1]
        local iY = pPos[3]

        local iPx = iX
        local iPy = iY

        for j = 1, iLoopY, 1 do
            iPx = draw_pattern_box_element(pImgBox, pQuad, iPx, iPy)

            iPx = iX
            iPy = fetch_next_pattern_vpos(pQuad, iPy)
        end
    end
end

local function draw_pattern_box_corner(pImgBox, rgpBoxQuads, rgpQuadFitPos)
    love.graphics.setScissor()

    for _, sBoxPos in ipairs({tBoxPos.LT, tBoxPos.RT, tBoxPos.RB, tBoxPos.LB}) do
        local pQuad = rgpBoxQuads[sBoxPos]
        local pPos = rgpQuadFitPos[sBoxPos]

        local iX = pPos[1]
        local iY = pPos[3]

        local iPx = iX
        local iPy = iY

        iPx = draw_pattern_box_element(pImgBox, pQuad, iPx, iPy)
    end

end

local function calc_pattern_element_fit(iLx, iTy, iRx, iBy, iW, iH, bFromRight, bFromBottom)
    local iX = bFromRight and iRx - iW or iLx
    local iY = bFromBottom and iBy - iH or iTy

    return {iX, iW, iY, iH}
end

local function calc_pattern_box_fit(rgpBoxQuads, fLoopX, fLoopY, iLx, iTy, iBoxWidth, iBoxHeight)
    local iWidthLT = get_quad_width(rgpBoxQuads[tBoxPos.LT])
    local iWidthT = fLoopX * get_quad_width(rgpBoxQuads[tBoxPos.T])
    local iWidthRT = get_quad_width(rgpBoxQuads[tBoxPos.RT])

    local iHeightLT = get_quad_height(rgpBoxQuads[tBoxPos.LT])
    local iHeightL = fLoopY * get_quad_height(rgpBoxQuads[tBoxPos.L])
    local iHeightLB = get_quad_height(rgpBoxQuads[tBoxPos.LB])

    local iPatWidth = iWidthLT + iWidthT + iWidthRT
    local iPatHeight = iHeightLT + iHeightL + iHeightLB

    local iRx = iLx + iPatWidth
    local iBy = iTy + iPatHeight

    local rgpQuadFitPos = {}

    rgpQuadFitPos[tBoxPos.LT] = calc_pattern_element_fit(iLx, iTy, iRx, iBy, iWidthLT, iHeightLT, false, false)
    rgpQuadFitPos[tBoxPos.T] = calc_pattern_element_fit(iLx + iWidthLT, iTy, iRx, iBy, iWidthT, iHeightLT, false, false)
    rgpQuadFitPos[tBoxPos.RT] = calc_pattern_element_fit(iLx, iTy, iRx, iBy, iWidthRT, iHeightLT, true, false)
    rgpQuadFitPos[tBoxPos.R] = calc_pattern_element_fit(iLx, iTy + iHeightLT, iRx, iBy, iWidthRT, iHeightL, true, false)
    rgpQuadFitPos[tBoxPos.RB] = calc_pattern_element_fit(iLx, iTy, iRx, iBy, iWidthRT, iHeightLB, true, true)
    rgpQuadFitPos[tBoxPos.B] = calc_pattern_element_fit(iLx + iWidthLT, iTy, iRx, iBy, iWidthT, iHeightLB, false, true)
    rgpQuadFitPos[tBoxPos.LB] = calc_pattern_element_fit(iLx, iTy, iRx, iBy, iWidthLT, iHeightLB, false, true)
    rgpQuadFitPos[tBoxPos.L] = calc_pattern_element_fit(iLx, iTy + iHeightLT, iRx, iBy, iWidthLT, iHeightL, false, false)
    rgpQuadFitPos[tBoxPos.M] = calc_pattern_element_fit(iLx + iWidthLT, iTy + iHeightLT, iRx, iBy, iWidthT, iHeightL, false, false)

    return rgpQuadFitPos, iWidthT, iHeightL
end

local function draw_pattern_box(pCanvas, pImgBox, rgpBoxQuads, pGrowth, iBoxWidth, iBoxHeight, iX, iY)
    local fLoopX
    local fLoopY
    fLoopX, fLoopY = unpack(pGrowth)

    local iBoxMidWidth
    local iBoxMidHeight
    local rgpQuadFitPos
    rgpQuadFitPos, iBoxMidWidth, iBoxMidHeight = calc_pattern_box_fit(rgpBoxQuads, fLoopX, fLoopY, iX, iY, iBoxWidth, iBoxHeight)

    local iLoopX = math.ceil(fLoopX)
    local iLoopY = math.ceil(fLoopY)

    pCanvas:renderTo(function()
        love.graphics.clear()

        draw_pattern_box_mid(pImgBox, rgpBoxQuads, rgpQuadFitPos, iLoopX, iLoopY, iX, iY, iBoxMidWidth, iBoxMidHeight)
        draw_pattern_box_side(pImgBox, rgpBoxQuads, rgpQuadFitPos, iLoopX, iLoopY, iX, iY, iBoxMidWidth, iBoxMidHeight, iBoxWidth, iBoxHeight)
        draw_pattern_box_corner(pImgBox, rgpBoxQuads, rgpQuadFitPos)
    end)
end

function draw_canvas_texture_box(pCanvas, pImgBox, rgpBoxQuads, pGrowth, iBoxWidth, iBoxHeight)
    draw_pattern_box(pCanvas, pImgBox, rgpBoxQuads, pGrowth, iBoxWidth, iBoxHeight, 0, 0)
end

function draw_texture_box(pCanvas, iPx, iPy)
    love.graphics.draw(pCanvas, iPx, iPy)
end
