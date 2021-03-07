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

    local rgiBoxOuter = { {0, 0}, {iWidth, 0}, {iWidth, iHeight}, {0, iHeight} }
    return rgiBoxOuter
end

local function fetch_inner_split(iL, iT, iR, iB)
    local rgiBoxInner = { {iL, iT}, {iR, iT}, {iR, iB}, {iL, iB} }
    return rgiBoxInner
end

local function fetch_decomp_img_coord(iOx, iOy, iIx, iIy)
    local iLx, iRx, iTy, iBy

    if iOx < iIx then
        iLx = iOx
        iRx = iIx
    else
        iLx = iIx
        iRx = iOx
    end

    if iOy < iIy then
        iTy = iOy
        iBy = iIy
    else
        iTy = iIy
        iBy = iOy
    end

    return iLx, iRx, iTy, iBy
end

local function decompose_box_image(pImgBox, rgiBoxOuter, rgiBoxInner)
    -- rgiBox Coords:
    -- top-left, top-right, bottom-right, bottom-left

    -- boxParts:
    -- Top-left, top, Top-right, Right, Bottom-right, Bottom, Bottom-left, Left

    local iBoxWidth
    local iBoxHeight
    iBoxWidth, iBoxHeight = pImgBox:getDimensions()

    local rgpBoxQuads = {}
    log_st(LPath.INTERFACE, "_tbox.txt", "WDHT [" .. iBoxWidth .. ", " .. iBoxHeight .. "]")

    -- quad corners
    for i = 1, #rgiBoxOuter, 1 do
        local iOx, iOy = unpack(rgiBoxOuter[i])
        local iIx, iIy = unpack(rgiBoxInner[i])
        local iLx, iRx, iTy, iBy = fetch_decomp_img_coord(iOx, iOy, iIx, iIy)

        log_st(LPath.INTERFACE, "_tbox.txt", "PART " .. i .. " [" .. iLx .. ", " .. (iRx - iLx) .. ", " .. iTy .. ", " .. (iBy - iTy) .. "]")
        local pQuad = love.graphics.newQuad(iLx, iRx - iLx, iTy, iBy - iTy, iBoxWidth, iBoxHeight)
        table.insert(rgpBoxQuads, pQuad)
    end

    -- quad middle
    local iLx, iRx, iTy, iBy
    iLx, iTy = unpack(rgiBoxInner[1])
    iRx, iBy = unpack(rgiBoxInner[3])

    local pQuad = love.graphics.newQuad(iLx, iRx - iLx, iTy, iBy - iTy, iBoxWidth, iBoxHeight)
    table.insert(rgpBoxQuads, pQuad)

    return rgpBoxQuads
end

-- boxParts:
-- Top-left, top, Top-right, Right, Bottom-right, Bottom, Bottom-left, Left
local tBoxQuad = {LT = 1, T = 2, RT = 3, R = 4, RB = 5, B = 6, LB = 7, L = 8, M = 9}

function fetch_texture_split(pImgBox, iL, iT, iR, iB)
    local rgiBoxOuter = fetch_outer_split(pImgBox)
    local rgiBoxInner = fetch_inner_split(iL, iT, iR, iB)

    local rgpQuadsBox = decompose_box_image(pImgBox, rgiBoxOuter, rgiBoxInner)
    return rgpQuadsBox
end

local function calc_texture_dimensions(pImgBox, rgpQuadsBox, iWidth, iHeight)
    -- Diagonals do not repeat
    local iExtX = iWidth - (rgpQuadsBox[tBoxQuad.LT]:getWidth() + rgpQuadsBox[tBoxQuad.RT]:getWidth())
    local iExtY = iHeight - (rgpQuadsBox[tBoxQuad.LT]:getHeight() + rgpQuadsBox[tBoxQuad.LB]:getHeight())

    local iLoopX = math.ceil(iExtX / rgpQuadsBox[tBoxQuad.T]:getWidth())
    local iLoopY = math.ceil(iExtY / rgpQuadsBox[tBoxQuad.L]:getHeight())

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
