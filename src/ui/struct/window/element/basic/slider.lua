--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("ui.constant.path")
require("ui.struct.component.basic.base")
require("ui.run.draw.canvas.slider.slider")
require("ui.run.update.canvas.position")
require("utils.struct.class")

RSliderState = {DISABLED = "disabled", MOUSE_OVER = "mouseOver", NORMAL = "normal", PRESSED = "pressed"}

CSliderElem = createClass({
    eElem = CBasicElem:new(),

    iLength,    -- slider length
    eThumb,         -- moves freely inside slider
    pImgBase,
    pImgPrev,
    pImgNext,

    iSgmtCur = 0,
    iSgmtCount = 0,

    bVert
})

function CSliderElem:get_object()
    return self
end

function CSliderElem:get_origin()
    return self.eElem:get_pos()
end

function CSliderElem:get_arrow_length()
    local iW, iH = self.pImgPrev:getDimensions()
    return bVert and iW or iH
end

function CSliderElem:get_arrow_girth()
    local iW, iH = self.pImgPrev:getDimensions()
    return bVert and iH or iW
end

function CSliderElem:get_bar_length()
    return self.iLength
end

function CSliderElem:get_thumb()
    return self.eThumb
end

function CSliderElem:get_thumb_length()
    local iWidth
    iWidth, _ = self.eThumb:get_dimensions()

    return iWidth
end

function CSliderElem:get_thumb_girth()
    local iHeight
    _, iHeight = self.eThumb:get_dimensions()

    return iHeight
end

function CSliderElem:get_bar()
    return self.pImgBase
end

function CSliderElem:get_prev()
    return self.pImgPrev
end

function CSliderElem:get_next()
    return self.pImgNext
end

function CSliderElem:get_wheel_segment()
    return self.iSgmtCur
end

function CSliderElem:set_wheel_segment(iCur)
    self.iSgmtCur = iCur
end

function CSliderElem:get_num_segments()
    return self.iSgmtCount
end

function CSliderElem:_set_num_segments(iCount)
    self.iSgmtCount = iCount
end

function CSliderElem:set_num_segments(iCount)
    self:_set_num_segments(iCount)

    if self:get_wheel_segment() > iCount then
        self:set_wheel_segment(iCount)
    end
end

function CSliderElem:is_vert()
    return self.bVert
end

function CSliderElem:_set_vert(bVert)
    self.bVert = bVert
end

function CSliderElem:get_ltrb()
    local iLx, iTy = self:get_origin()
    local iRx, iBy

    local iLen = self:get_bar_length()

    local iGir = self:get_arrow_girth()

    local bVert = self:is_vert()
    if bVert then
        iLx = iLx - math.ceil(iGir / 2)

        iRx = iLx + iGir
        iBy = iTy + iLen
    else
        iTy = iTy - math.ceil(iGir / 2)

        iRx = iLx + iLen
        iBy = iTy + iGir
    end

    return iLx, iTy, iRx, iBy
end

local function make_thumb_texture(pImgThumb)
    local iWidth
    local iHeight
    iWidth, iHeight = pImgThumb:getDimensions()

    local eThumb = CTextureElem:new()
    eThumb:load(0, 0, pImgThumb, 3, 3, 13, 6)
    eThumb:build(iWidth, iHeight)

    return eThumb
end

local function make_thumb_empty()
    local eThumb = CTextureElem:new()
    eThumb:load(0, 0, nil)
    eThumb:build(0, 0)

    return eThumb
end

function CSliderElem:_load_arrows(sThumbName)
    self.pImgPrev = ctVwSlider:get_prev(sThumbName)
    self.pImgNext = ctVwSlider:get_next(sThumbName)
end

function CSliderElem:_load_bar(sThumbName)
    local pImgFilBase = ctVwSlider:get_bar(sThumbName)
    self.pImgBase = pImgFilBase
end

function CSliderElem:_load_thumb(sThumbName)
    local eThumb
    if sThumbName ~= RSliderState.DISABLED then
        eThumb = make_thumb_texture(ctVwSlider:get_thumb(sThumbName))
    else
        eThumb = make_thumb_empty()
    end

    self.eThumb = eThumb
end

function CSliderElem:build_thumb(nSgmts, iLen, bDefWidth)
    local m_eThumb = self.eThumb

    local iWidth
    local iHeight
    iWidth, iHeight = m_eThumb:get_dimensions()

    if not bDefWidth then
        iWidth = math.floor(iLen / nSgmts)
    end

    self:_set_num_segments(nSgmts)
    self:set_wheel_segment(math.min(self:get_wheel_segment(), nSgmts))

    local m_eThumb = self.eThumb
    m_eThumb:build(iWidth, iHeight)
end

function CSliderElem:update_box(iLen, bVert)
    self.iLength = iLen
    self:_set_vert(bVert)
end

function CSliderElem:_update_slider(iLen, nSgmts, bDefWidth, bVert)
    self:build_thumb(nSgmts, iLen, bDefWidth)
    self:update_box(iLen, bVert)
end

function CSliderElem:_calc_trail_length(iLen)
    local iRollLen = iLen - (2 * self:get_arrow_length())
    return iRollLen
end

function CSliderElem:get_trail_length()
    local iLen = self:get_bar_length()
    return self:_calc_trail_length(iLen)
end

function CSliderElem:_calc_segment_size(iLen)
    local iRollLen = self:_calc_trail_length(iLen)
    local iBarLen = self:get_bar():getWidth()

    local iSgmt = math.ceil(iRollLen / iBarLen)
    return iSgmt
end

local function is_in_range(x, y, iLx, iTy, iRx, iBy)
    return math.between(x, iLx, iRx) and math.between(y, iTy, iBy)
end

local function is_mouse_in_range(pElem, x, y)
    local iLx, iTy, iRx, iBy = pElem:get_ltrb()
    return is_in_range(x, y, iLx, iTy, iRx, iBy)
end

function CSliderElem:_get_current_state(sSliderState)
    if sSliderState ~= RSliderState.DISABLED then
        local x, y = love.mouse.getPosition()
        if is_mouse_in_range(self, x, y) then
            sSliderState = RSliderState.MOUSE_OVER
        end
    end

    return sSliderState
end

function CSliderElem:update_state(sSliderState)
    sSliderState = self:_get_current_state(sSliderState)

    self:_load_bar(sSliderState)
    self:_load_thumb(sSliderState)
    self:_load_arrows(sSliderState)
end

function CSliderElem:onmousehoverin()
    local bDisabled = self:get_num_segments() < 1
    if bDisabled then
        --pFrameBasic:get_cursor():load_mouse(RWndPath.MOUSE.BT_NORMAL)
        return
    end

    if self:is_vert() then
        pFrameBasic:get_cursor():load_mouse(RWndPath.MOUSE.BT_SCROLL_Y)
    else
        pFrameBasic:get_cursor():load_mouse(RWndPath.MOUSE.BT_SCROLL_X)
    end
end

function CSliderElem:onmousehoverout()
    local bDisabled = self:get_num_segments() < 1
    if bDisabled then
        pFrameBasic:get_cursor():load_mouse(RWndPath.MOUSE.BT_NORMAL)
        return
    end

    if self:is_vert() then
        pFrameBasic:get_cursor():load_mouse(-RWndPath.MOUSE.BT_SCROLL_Y)
    else
        pFrameBasic:get_cursor():load_mouse(-RWndPath.MOUSE.BT_SCROLL_X)
    end
end

function CSliderElem:get_arrow_positions()
    local bVert = self:is_vert()

    local iRx = 0
    local iRy = 0

    local pImgFilBase = self:get_bar()
    local _, iFilMidGir = pImgFilBase:getDimensions()

    local iX, iY = self:get_origin()
    local iPx, iPy = iX, iY

    local iBarLen = self:get_bar_length()

    local iArrLen = self:get_arrow_length()
    local iArrGir = self:get_arrow_girth()

    if bVert then
        iPx = iPx - math.ceil(iFilMidGir / 2)
        iPy = iPy + iArrGir

        iRy = iBarLen - iArrGir
    else
        iPx = iPx + iArrGir
        iPy = iPy - math.ceil(iFilMidGir / 2)

        iRx = iBarLen - iArrGir
    end

    return iPx, iPy, iPx + iRx, iPy + iRy
end

function CSliderElem:onmousereleased(x, y, button)
    if button == 1 then
        local iNx, iNy, iPx, iPy = self:get_arrow_positions()
        local bVert = self:is_vert()

        local iX, iY
        if bVert then
            iX = self:get_arrow_length()
            iY = self:get_arrow_girth()

            iNy = iNy - iY
            iPy = iPy - iY
        else
            iX = self:get_arrow_girth()
            iY = self:get_arrow_length()

            iNx = iNx - iX
            iPx = iPx - iX
        end

        if is_in_range(x, y, iNx, iNy, iNx + iX, iNy + iY) then
            local pInvt = pUiInvt:get_properties():get_inventory()
            pInvt:_update_row(-1)
        elseif is_in_range(x, y, iPx, iPy, iPx + iX, iPy + iY) then
            local pInvt = pUiInvt:get_properties():get_inventory()
            pInvt:_update_row(1)
        end
    end
end

function CSliderElem:load(sSliderState, iLen, bDefWidth, bVert, rX, rY)
    self.eElem:load(rX, rY)
    self:update_state(RSliderState.DISABLED)

    local nSgmts = self:_calc_segment_size(iLen)
    self:_update_slider(iLen, nSgmts, bDefWidth, bVert)

    self:update_state(sSliderState)
end

function CSliderElem:update(dt)
    -- do nothing
end

function CSliderElem:draw()
    draw_slider(self)
end
