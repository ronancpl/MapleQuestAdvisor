--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("ui.constant.view.inventory")

local function fetch_item_tile_center(pImgItem, iPx, iPy, iBw, iBh)
    local iW
    local iH
    iW, iH = pImgItem:getDimensions()

    local fSc
    if iW < iBw and iW < iH then
        fSc = iBh / math.min(iH, iBh)
    else
        fSc = iBw / math.min(iW, iBw)
    end

    local iCx = iPx + (iBw / 2)
    local iCy = iPy + (iBh / 2)

    return iCx, iCy, iW, iH, fSc
end

local function fetch_item_tile_position(fSc, pImg, iCx, iCy)
    local iW
    local iH
    iW, iH = pImg:getDimensions()

    iW = fSc * iW
    iH = fSc * iH

    local iX = iCx - (iW / 2)
    local iY = iCy - (iH / 2)

    return iX, iY, iW, iH
end

local function fetch_item_tile_scale(pImgItem, pImgShd, fSc, iCx, iCy, iBw, iBh)
    local iImgX, iImgY, iImgW, iImgH = fetch_item_tile_position(fSc, pImgItem, iCx, iCy)

    local iShPx, iShPy, iShW, iShH = fetch_item_tile_position(1.0, pImgShd, iCx, iCy)
    iShPy = iBh - (iShPy / 2)

    return iImgX, iImgY, iImgW, iImgH, iShPx, iShPy, iShW, iShH
end

local function amend_item_tile_positions(pImgItem, iImgX, iImgY, iImgW, iImgH)
    iImgX = iImgX + math.ceil((iImgW - pImgItem:getWidth()) / 2)
    iImgY = iImgY + math.floor((iImgH - pImgItem:getHeight()) / 2)
    iImgW = pImgItem:getWidth()
    iImgH = pImgItem:getHeight()

    return iImgX, iImgY, iImgW, iImgH
end

function fetch_item_tile_box_invt(pImgItem, pImgShd, iPx, iPy, iWidth, iHeight)
    local iBw = iWidth
    local iBh = iHeight

    local iCx, iCy, iW, iH, fSc = fetch_item_tile_center(pImgItem, iPx, iPy, iBw, iBh)
    local iImgX, iImgY, iImgW, iImgH, iShPx, iShPy, iShW, iShH = fetch_item_tile_scale(pImgItem, pImgShd, fSc, iCx, iCy, iBw, iBh)
    iImgX, iImgY, iImgW, iImgH = amend_item_tile_positions(pImgItem, iImgX, iImgY, iImgW, iImgH)

    return iCx, iCy, iImgX, iImgY, iImgW, iImgH, iShPx, iShPy, iShW, iShH
end
