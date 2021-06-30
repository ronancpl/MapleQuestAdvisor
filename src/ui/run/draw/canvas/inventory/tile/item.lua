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

local function fetch_item_tile_center(pImgItem, iPx, iPy, iBw, iBh)
    local iW
    local iH
    iW, iH = pImgItem:getDimensions()

    local fSc = 1.0     -- constant, same size

    local iCx = iPx + math.floor(iBw / 2)
    local iCy = iPy + math.floor(iBh / 2)

    return iCx, iCy, iW, iH, fSc
end

local function fetch_item_tile_position(fSc, pImg, iCx, iCy)
    local iIw, iIh = pImg:getDimensions()

    local iW = fSc * iIw
    local iH = fSc * iIh

    local iX = iCx - math.floor(iW / 2)
    local iY = iCy - math.floor(iH / 2)

    return iX, iY, iW, iH
end

local function fetch_item_tile_scale(pImgItem, fSc, iCx, iCy)
    local iImgX, iImgY, iImgW, iImgH = fetch_item_tile_position(fSc, pImgItem, iCx, iCy)
    return iImgX, iImgY, iImgW, iImgH
end

local function fetch_shadow_tile_position(bEqp, pImgShd, pImgItem, iPx, iPy, iBw, iBh, iRx, iBy)
    local iRx = math.floor((iBw - pImgItem:getWidth()) / 2)
    local iRy = math.floor((iBh - pImgItem:getHeight()) / 2)

    local iOx = iPx + math.ceil(iBw / 2)
    local iOy = iPy + math.ceil(iBh / 2)

    local iShPx, iShPy, iShW, iShH = fetch_item_tile_position(1.0, pImgShd, iOx, iOy)
    iShPy = math.min(math.ceil((iBh - pImgItem:getHeight()) / 2), 0)
    iShPy = iBh - pImgShd:getHeight()

    local iEx = 0
    local iEy = math.floor(math.max(iBh - iBy, 0) / 2) + 4

    return iShPx - iRx - iEx, iShPy - iEy, iShW, iShH
end

local function amend_item_tile_positions(bEqp, iCx, iCy, iImgX, iImgY, iImgW, iImgH, iBw, iBh, iRx, iBy)
    iImgX = iCx - math.ceil(iImgW / 2)
    iImgX = math.iclamp(iImgX, 0, iBw - iImgW)
    iImgX = math.ceil(iImgX / 2)

    iImgY = iCy - math.ceil(iImgH / 2)
    iImgY = math.iclamp(iImgY, 0, iBh - iImgH)
    iImgY = math.ceil(iImgY / 2)

    if bEqp ~= nil and not bEqp then
        iImgY = math.floor(math.max(iBh - iBy, 0) / 2)
    end

    return iImgX, iImgY, iImgW, iImgH
end

function fetch_item_tile_box_invt(pImgItem, pImgShd, bEqp, iPx, iPy, iCnvW, iCnvH, iBw, iBh)
    local iImgW = pImgItem:getWidth()
    local iImgH = pImgItem:getHeight()

    local iCx, iCy, iW, iH, fSc = fetch_item_tile_center(pImgItem, iPx, iPy, iCnvW, iCnvH)
    local iImgX, iImgY, iImgW, iImgH = fetch_item_tile_scale(pImgItem, fSc, iCx, iCy)
    iImgX, iImgY, iImgW, iImgH = amend_item_tile_positions(bEqp, iCx, iCy, iImgX, iImgY, iImgW, iImgH, iCnvW, iCnvH, iBw, iBh)

    local iShPx, iShPy, iShW, iShH = fetch_shadow_tile_position(bEqp, pImgShd, pImgItem, iPx, iPy, iCnvW, iCnvH, iBw, iBh)
    return iCx, iCy, iImgX, iImgY, iImgW, iImgH, iShPx, iShPy, iShW, iShH
end
