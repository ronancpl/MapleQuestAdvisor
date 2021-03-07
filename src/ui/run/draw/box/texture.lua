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

local function decomp_img_quad(iSx, iSy, iTx, iTy)
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

local function decomp_img_segment(iStU, iStV, iMidStU, iMidStV, iMidEnU, iMidEnV, iEnU, iEnV)
    local rgpPos = {}

    table.insert(rgpPos, decomp_img_quad(iStU, iStV, iMidStU, iMidStV))
    table.insert(rgpPos, decomp_img_quad(iMidStU, iStV, iMidEnU, iMidEnV))
    table.insert(rgpPos, decomp_img_quad(iMidEnU, iStV, iEnU, iMidEnV))

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

    iEnU = iOu
    iEnV = iIv

    local rgpPos = decomp_img_segment(iStU, iStV, iMidStU, iMidStV, iMidEnU, iMidEnV, iEnU, iEnV)

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

local function decompose_box_image(pImgBox, rgpBoxOuter, rgpBoxInner)
    -- rgpBox Coords:
    -- top-left, top-right, bottom-right, bottom-left

    -- boxParts:
    -- Top-left, top, Top-right, Right, Bottom-right, Bottom, Bottom-left, Left

    local iBoxWidth
    local iBoxHeight
    iBoxWidth, iBoxHeight = pImgBox:getDimensions()

    local rgpBoxPos = {}
    log_st(LPath.INTERFACE, "_tbox.txt", "WDHT [" .. iBoxWidth .. ", " .. iBoxHeight .. "]")

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

    local rgpBoxQuads = {}
    for _, pPos in ipairs(rgpBoxPos) do
        local iLx, iW, iTy, iH = unpack(pPos)

        local pQuad = love.graphics.newQuad(iLx, iW, iTy, iH, iBoxWidth, iBoxHeight)
        table.insert(rgpBoxQuads, pQuad)
    end

    -- quad middle
    local iLx, iRx, iTy, iBy
    iLx, iTy = unpack(rgpBoxInner[1])
    iRx, iBy = unpack(rgpBoxInner[3])

    local pQuad = love.graphics.newQuad(iLx, iRx - iLx, iTy, iBy - iTy, iBoxWidth, iBoxHeight)
    table.insert(rgpBoxQuads, pQuad)

    return rgpBoxQuads
end

-- boxParts:
-- Top-left, top, Top-right, Right, Bottom-right, Bottom, Bottom-left, Left
local tBoxQuad = {LT = 1, T = 2, RT = 3, R = 4, RB = 5, B = 6, LB = 7, L = 8, M = 9}

function fetch_texture_split(pImgBox, iL, iT, iR, iB)
    local rgpBoxOuter = fetch_outer_split(pImgBox)
    local rgpBoxInner = fetch_inner_split(iL, iT, iR, iB)

    local rgpQuadsBox = decompose_box_image(pImgBox, rgpBoxOuter, rgpBoxInner)
    return rgpQuadsBox
end

local function get_quad_width(pQuad)
    local iRet
    iRet, _ = pQuad:getTextureDimensions()

    return iRet
end

local function get_quad_height(pQuad)
    local iRet
    _, iRet = pQuad:getTextureDimensions()

    return iRet
end

local function calc_texture_dimensions(pImgBox, rgpQuadsBox, iWidth, iHeight)
    -- Diagonals do not repeat

    local iExtX = iWidth - (get_quad_width(rgpQuadsBox[tBoxQuad.LT]) + get_quad_width(rgpQuadsBox[tBoxQuad.RT]))
    local iExtY = iHeight - (get_quad_height(rgpQuadsBox[tBoxQuad.LT]) + get_quad_height(rgpQuadsBox[tBoxQuad.LB]))

    local iLoopX = math.ceil(iExtX / get_quad_width(rgpQuadsBox[tBoxQuad.T]))
    local iLoopY = math.ceil(iExtY / get_quad_height(rgpQuadsBox[tBoxQuad.L]))

    return iLoopX, iLoopY
end

local function draw_pattern_box(pImgBox, rgpQuadsBox, iLoopX, iLoopY, iPx, iPy)
    love.graphics.draw(pImgBox, rgpQuadsBox[tBoxQuad.LT], iPx, iPy)

    for i = 1, iLoopY, 1 do
        love.graphics.draw(pImgBox, rgpQuadsBox[tBoxQuad.T], iPx, iPy)

    end

    love.graphics.draw(pImgBox, rgpQuadsBox[tBoxQuad.RT], iPx, iPy)

    for i = 1, iLoopX, 1 do
        love.graphics.draw(pImgBox, rgpQuadsBox[tBoxQuad.L], iPx, iPy)

        love.graphics.draw(pImgBox, rgpQuadsBox[tBoxQuad.M], iPx, iPy)

        love.graphics.draw(pImgBox, rgpQuadsBox[tBoxQuad.R], iPx, iPy)
    end

    love.graphics.draw(pImgBox, rgpQuadsBox[tBoxQuad.LB], iPx, iPy)

    for i = 1, iLoopY, 1 do
        love.graphics.draw(pImgBox, rgpQuadsBox[tBoxQuad.B], iPx, iPy)
    end

    love.graphics.draw(pImgBox, rgpQuadsBox[tBoxQuad.RB], iPx, iPy)
end

function draw_texture_box(pImgBox, rgpQuadsBox, iWidth, iHeight, iPx, iPy)
    local iLoopX
    local iLoopY
    iLoopX, iLoopY = calc_texture_dimensions(pImgBox, rgpQuadsBox, iWidth, iHeight)

    draw_pattern_box(pImgBox, rgpQuadsBox, iLoopX, iLoopY, iPx, iPy)
end
