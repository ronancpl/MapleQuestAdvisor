--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("utils.struct.class")

local SBOX_CRLF = 5
local SBOX_MIN_X = 100
local SBOX_MAX_X = 500
local SBOX_FIL_X = 10
local SBOX_UPD_X = 200

local SBOX_MIN_Y = 80
local SBOX_MAX_Y = 200
local SBOX_FIL_X = 10
local SBOX_UPD_Y = SBOX_CRLF    -- + font height

local WND_X = 640
local WND_Y = 470

CStyleBoxText = createClass(CWmapComponent, {
    sTitle,
    pFontTitle,
    pTxtTitle,

    sDesc,
    pFontDesc,
    pTxtDesc,

    iGrowth,
    iWidth,
    rgpBoxParts
})

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

local function decompose_box_image(pImgBoxDim, rgiBoxOuter, rgiBoxInner)
    -- rgiBox Coords:
    -- top-left, top-right, bottom-right, bottom-left

    -- boxParts:
    -- Top-left, top, Top-right, Right, Bottom-right, Bottom, Bottom-left, Left

    local rgpBoxParts = {}

    for i = 1, #rgiBoxOuter, 1 do
        local iOx, iOy = unpack(rgiBoxOuter[i])
        local iIx, iIy = unpack(rgiBoxInner[i])
        iLx, iRx, iTy, iBy = fetch_decomp_img_coord(iOx, iOy, iIx, iIy)

        local pPart = love.graphics.newQuad(iLx, iRx - iLx, iTx, iBy - iTy, pImgBoxDim)
        table.insert(rgpBoxParts, pPart)
    end

    return rgpBoxParts
end

function CStyleBoxText:load_graphics()
    local pImgBox = love.graphics.newImage(RInterface.SBOX_DESC)

    local rgiBoxOuter = { {0, 0}, {121, 0}, {121, 19}, {0, 19} }
    local rgiBoxInner = { {3, 3}, {118, 3}, {118, 16}, {3, 16} }

    local rgpBoxParts = decompose_box_image(pImgBox:getDimensions(), rgiBoxOuter, rgiBoxInner)
    self.rgpBoxParts = rgpBoxParts
end

function CStyleBoxText:load_fonts()
    self.iGrowth = 0
    self.iWidth = SBOX_MIN_X

    self.pFontTitle = love.graphics.newFont("fonts/font.ttf", 16)
    self.pFontDesc = love.graphics.newFont("fonts/font.ttf", 16)
end

function CStyleBoxText:compose_box_text()
    local pTxtTitle = love.graphics.newText(self.pFontTitle)
    self.pTxtTitle = pTxtTitle:setf({{1, 1, 1}, self.sTitle}, self.iWidth, "center")

    local pTxtDesc = love.graphics.newText(self.pFontDesc)
    self.pTxtDesc = pTxtDesc:setf({{1, 1, 1}, self.sDesc}, self.iWidth, "justify")
end

function CStyleBoxText:set_box_text(sTitle, sDesc)
    self.pFontTitle = sTitle
    self.pFontDesc = sDesc

    self:compose_box_text()
end

function CStyleBoxText:get_width()
    return self.iWidth
end

function CStyleBoxText:get_height()
    local m_pTxtTitle = self.pTxtTitle
    local m_pTxtDesc = self.pTxtDesc

    return m_pTxtTitle:getHeight() + (2 * SBOX_CRLF) + m_pTxtDesc:getHeight()
end

function CStyleBoxText:adjust_box_boundary()
    self.iGrowth = self.iGrowth + 1

    if self.iGrowth % 2 == 0 and self.iWidth < SBOX_MAX_X - (2 * SBOX_FIL_X) then
        self.iWidth = self.iWidth + SBOX_UPD_X
    else
        -- self.iHeight = self.iHeight + SBOX_UPD_Y
    end
end

function CStyleBoxText:validate_box_boundary()
    while true do
        local iHeight = self:get_height()
        if iHeight < self.iHeight then
            break
        end

        self:adjust_box_boundary()  -- accommodate text field in style box canvas
        self:compose_box_text()
    end
end

function CStyleBoxText:load(sTitle, sDesc)
    self:load_graphics()
    self:load_fonts()

    self:set_box_text(sTitle, sDesc)
    self:validate_box_boundary()
end

local function fetch_box_body_placement(iMx, iMy)
    local iWidth = self:get_width()
    if(iMx + iWidth < WND_X) iRefX = iMx;
    else iRefX = iMx - iWidth;

    local iHeight = self:get_height()
    if(iMy + iHeight < WND_Y) iRefY = iMy;
    else iRefY = iMy - iHeight;

    return iRefX, iRefY
end

function CStyleBoxText:update(dt)
    local iX, iY = fetch_box_body_placement(unpack(love.mouse.getPosition()))

end

function CStyleBoxText:draw()
    love.graphics.draw(self.bg)
end
