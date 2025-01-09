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
require("ui.constant.path")
require("ui.constant.view.selectbox")
require("ui.struct.component.basic.base")
require("ui.struct.window.summary")
require("ui.struct.window.element.basic.selectbox_extended")
require("ui.run.draw.canvas.selectbox.selectbox")
require("ui.run.update.canvas.position")
require("ui.texture.composition")
require("utils.procedure.unpack")
require("utils.struct.class")

RSelectBoxState = {DISABLED = "disabled", MOUSE_OVER = "mouseOver", NORMAL = "normal", PRESSED = "pressed", SELECTED = "selected"}

CSelectBoxElem = createClass({
    eElem = CBasicElem:new(),
    pTxtDataBox,
    eBox,

    rgsTextList = {},    -- SelectBox text options
    rgpFontOpts = {},

    iOpt,
    iPos = 1
})

function CSelectBoxElem:get_object()
    return self
end

function CSelectBoxElem:get_origin()
    return self.eElem:get_pos()
end

function CSelectBoxElem:get_cover_box()
    return self.eBox
end

function CSelectBoxElem:_set_cover_box(eBox)
    self.eBox = eBox
end

function CSelectBoxElem:get_opt()
    return self.iOpt
end

function CSelectBoxElem:_set_opt(iOpt)
    self.iOpt = iOpt
end

function CSelectBoxElem:get_num_options()
    return #self.rgsTextList
end

function CSelectBoxElem:_set_text_options(rgsTextList)
    local iNumTexts = math.min(#rgsTextList, RSelectbox.VW_SELECTBOX.NUM_LINES)
    local rgsTextOpts = {}
    for i = 1, iNumTexts, 1 do
        table.insert(rgsTextOpts, rgsTextList[i])
    end

    self.rgsTextList = rgsTextOpts
end

function CSelectBoxElem:get_text(iOpt)
    return self.rgsTextList[iOpt]
end

function CSelectBoxElem:get_text_opt()
    return self:get_text(self:get_opt())
end

function CSelectBoxElem:reset()
    self:clear_extended()
end

function CSelectBoxElem:get_ltrb()
    local iLx, iTy, iRx, iBy = self:get_cover_box():get_ltrb()
    local iPx, iPy = self:get_origin()

    iLx = iLx + iPx
    iTy = iTy + iPy
    iRx = iRx + iPx
    iBy = iBy + iPy

    return iLx, iTy, iRx, iBy
end

local function is_in_range(x, y, iLx, iTy, iRx, iBy)
    return math.between(x, iLx, iRx) and math.between(y, iTy, iBy)
end

local function is_mouse_in_range(pElem, x, y)
    local iLx, iTy, iRx, iBy = pElem:get_ltrb()
    return is_in_range(x, y, iLx, iTy, iRx, iBy)
end

function CSelectBoxElem:_make_selectbox_texture(pImgL, pImgC, pImgR)
    local rgpImgBox = {}
    table.insert(rgpImgBox, pImgL)
    table.insert(rgpImgBox, pImgC)
    table.insert(rgpImgBox, pImgR)

    local pImgBox, iIx, iIy, iIw, iIh, iOx, iOy, iOw, iOh = compose_texture_from_imageset(rgpImgBox, 3, 15, 15)

    local pTxtDataBox = CBasicTexture:new()
    pTxtDataBox:load(pImgBox, iIx, iIy, iIw, iIh, iOx, iOy, iOw, iOh)

    self.pTxtDataBox = pTxtDataBox
end

function CSelectBoxElem:_load_selectbox_texture(sSelectBoxState)
    local pImgL = ctVwSelectBox:get_left(sSelectBoxState)
    local pImgC = ctVwSelectBox:get_center(sSelectBoxState)
    local pImgR = ctVwSelectBox:get_right(sSelectBoxState)

    self:_make_selectbox_texture(pImgL, pImgC, pImgR)
end

function CSelectBoxElem:_load_selectbox_text(pFontOpt, sText, iWidth, bTextCover)
    local pTxtOpt = ctPoolFont:take_text(pFontOpt)
    if bTextCover then
        pTxtOpt:setf({{1, 1, 1}, sText}, iWidth, "left")
    else
        pTxtOpt:setf({{0, 0, 0}, sText}, iWidth, "left")
    end

    return pTxtOpt
end

function CSelectBoxElem:_load_selectbox_fonts()
    local m_rgpFontOpts = self.rgpFontOpts
    clear_table(m_rgpFontOpts)

    local m_rgsTextList = self.rgsTextList
    for _, sText in ipairs(m_rgsTextList) do
        local pFontOpt

        local i = 12
        while i > 2 do
            local iWidth

            pFontOpt = ctPoolFont:take_font(RWndPath.LOVE_FONT_DIR_PATH .. "arial.ttf", i)
            iWidth, _ = pFontOpt:getWrap(sText, U_INT_MAX)

            if iWidth <= RSelectbox.VW_SELECTBOX.LINE_W - RSelectbox.VW_SELECTBOX.LINE_ST_W then
                break
            end

            i = i - 1
        end

        table.insert(m_rgpFontOpts, pFontOpt)
    end
end

function CSelectBoxElem:_fetch_text_opt(iIdx, bTextCover)
    local m_rgpFontOpts = self.rgpFontOpts
    local m_rgsTextList = self.rgsTextList

    local pFontOpt = m_rgpFontOpts[iIdx]
    local sText = m_rgsTextList[iIdx]

    local pTxtOpt = self:_load_selectbox_text(pFontOpt, sText, RSelectbox.VW_SELECTBOX.LINE_W, bTextCover)
    return pTxtOpt
end

function CSelectBoxElem:fetch_visible_texts()
    local rgpTxtOpts = {}

    local m_rgpFontOpts = self.rgpFontOpts
    for i = 1, #m_rgpFontOpts, 1 do
        local pTxtOpt = self:_fetch_text_opt(i, true)
        table.insert(rgpTxtOpts, pTxtOpt)
    end

    return rgpTxtOpts
end

function CSelectBoxElem:free_visible_text(pTxtOpt)
    local m_rgpFontOpts = self.rgpFontOpts
    local pFontOpt = m_rgpFontOpts[self:get_opt()]

    ctPoolFont:put_text(pFontOpt, pTxtOpt)
end

function CSelectBoxElem:free_visible_texts(rgpTxtOpts)
    local m_rgpFontOpts = self.rgpFontOpts
    for i = 1, #m_rgpFontOpts, 1 do
        local pFontOpt = m_rgpFontOpts[i]
        local pTxtOpt = rgpTxtOpts[i]

        ctPoolFont:put_text(pFontOpt, pTxtOpt)
    end
end

function CSelectBoxElem:_reset_visible_position()
    self.iPos = 1
    self.iOpt = nil
end

function CSelectBoxElem:_build_selectbox_texture()
    local pImgBox, iIx, iIy, iIw, iIh, iOx, iOy, iOw, iOh = self.pTxtDataBox:get()

    local eTexture = CTextureElem:new()
    eTexture:load(0, 0, pImgBox, iIx, iIy, iIw, iIh, iOx, iOy, iOw, iOh)
    eTexture:build(RSelectbox.VW_SELECTBOX.LINE_W, RSelectbox.VW_SELECTBOX.LINE_H)

    self:_set_cover_box(eTexture)
end

function CSelectBoxElem:set_text_options(rgsTextList)
    self:_reset_visible_position()
    self:_set_text_options(rgsTextList)
    self:_load_selectbox_fonts()
    self:_build_selectbox_texture()
end

function CSelectBoxElem:get_text_selected()
    if self:get_opt() ~= nil then
        return self:_fetch_text_opt(self:get_opt(), false)
    else
        return nil
    end
end

function CSelectBoxElem:set_select_option(iOpt)
    self:_set_opt(iOpt)
end

function CSelectBoxElem:get_state()
    return self.sState
end

function CSelectBoxElem:update_state(sSelectBoxState)
    self:_load_selectbox_texture(sSelectBoxState)
    self:_build_selectbox_texture()
    self.sState = sSelectBoxState
end

function CSelectBoxElem:get_extended()
    return self.pSlctEx
end

function CSelectBoxElem:set_extended(pSlctEx)
    self.pSlctEx = pSlctEx
end

function CSelectBoxElem:load(sSelectBoxState, rX, rY)
    self.eElem:load(rX, rY)
    self:update_state(sSelectBoxState)
    self:set_text_options({})
end

function CSelectBoxElem:update(dt)
    -- do nothing
end

function CSelectBoxElem:draw(iPx, iPy)
    draw_selectbox(self, iPx, iPy)
end

function CSelectBoxElem:onmousehoverin()
    if self:get_state() == RSelectBoxState.DISABLED then return end
    self:update_state(love.mouse.isDown(1) and RSelectBoxState.PRESSED or RSelectBoxState.MOUSE_OVER)
end

function CSelectBoxElem:onmousehoverout()
    if self:get_state() == RSelectBoxState.DISABLED then return end
    self:update_state(love.mouse.isDown(1) and RSelectBoxState.PRESSED or RSelectBoxState.MOUSE_OVER)
end

function CSelectBoxElem:mount_extended()
    local iLx, _, _, iBy = self:get_ltrb()
    local iHeight = math.min(self:get_num_options(), RSelectbox.VW_SELECTBOX.NUM_LINES) * RSelectbox.VW_SELECTBOX.LINE_H
    iBy = iBy - iHeight - RSelectbox.VW_SELECTBOX.LINE_H

    local pSlctEx = CSelectBoxExtElem:new()
    pSlctEx:load(self, iLx, iBy, RSelectbox.VW_SELECTBOX.LINE_W, iHeight)

    pUiHud:get_misc_channel():add_element(pSlctEx)
end

function CSelectBoxElem:clear_extended()
    local pSlctEx = self:get_extended()
    if pSlctEx ~= nil then
        pUiHud:get_misc_channel():remove_element(pSlctEx)

        self:set_extended(nil)
        pSlctEx:reset()
    end
end

function CSelectBoxElem:onmousereleased(x, y, button)
    if button == 1 then
        if self:get_extended() == nil then
            self:mount_extended()
        else
            self:clear_extended()
        end
    end
end
