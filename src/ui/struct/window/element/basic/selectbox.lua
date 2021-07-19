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
require("ui.run.draw.canvas.selectbox.selectbox")
require("ui.run.update.canvas.position")
require("ui.texture.composition")
require("utils.struct.class")

RSelectBoxState = {DISABLED = "disabled", MOUSE_OVER = "mouseOver", NORMAL = "normal", PRESSED = "pressed", SELECTED = "selected"}

CSelectBoxElem = createClass({
    eElem = CBasicElem:new(),
    pTxtDataBox,
    eBox,

    rgsTextList = {},    -- SelectBox text options
    rgpTxtOpts = {},

    iOpt,
    iPos = 0
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
    self.rgsTextList = rgsTextList
    self:_set_opt(0)
end

function CSelectBoxElem:get_ltrb()
    return self:get_cover_box():get_ltrb()
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

function CSelectBoxElem:_load_selectbox_text(pFontOpt, sText, iWidth, bOptSlct)
    local pTxtOpt = ctPoolFont:take_text(pFontOpt)
    local rgiRgb = bOptSlct and {1, 1, 1} or {0, 0, 0}
    pTxtOpt:setf({rgiRgb, sText}, iWidth, "left")

    return pTxtOpt
end

function CSelectBoxElem:_free_selectbox_text(pTxtOpt)
    ctPoolFont:put_text(pTxtOpt)
end

function CSelectBoxElem:_load_selectbox_texts(iWidth)
    local pFontOpt = ctPoolFont:take_font(RWndPath.LOVE_FONT_DIR_PATH .. "arial.ttf", 12)

    local m_rgpTxtOpts = self.rgpTxtOpts
    clear_table(m_rgpTxtOpts)

    local m_rgsTextList = self.rgsTextList
    for _, sText in ipairs(m_rgsTextList) do
        local pTxtOpt = self:_load_selectbox_text(pFontOpt, sText, iWidth, false)
        table.insert(m_rgpTxtOpts, pTxtOpt)
    end
end

function CSelectBoxElem:_get_selectbox_line_width()
    local iVal = U_INT_MIN

    local m_rgpTxtOpts = self.rgpTxtOpts
    for _, pTxtItem in ipairs(m_rgpTxtOpts) do
        local iWidth = pTxtItem:getWidth()

        if iVal < iWidth then
            iVal = iWidth
        end
    end

    return iVal
end

function CSelectBoxElem:fetch_visible_items()
    local rgpTxtOpts = {}

    local m_rgpTxtOpts = self.rgpTxtOpts
    for i = self.iPos, #m_rgpTxtOpts, 1 do
        table.insert(rgpTxtOpts, m_rgpTxtOpts[i])
    end

    return rgpTxtOpts
end

function CSelectBoxElem:_reset_visible_position()
    self.iPos = nil
end

function CSelectBoxElem:_build_selectbox_texture()
    local m_rgpTxtOpts = self.rgpTxtOpts
    local iVal = self:_get_selectbox_line_width()

    local pImgBox, iIx, iIy, iIw, iIh, iOx, iOy, iOw, iOh = self.pTxtDataBox:get()

    local eTexture = CTextureElem:new()
    eTexture:load(0, 0, pImgBox, iIx, iIy, iIw, iIh, iOx, iOy, iOw, iOh)
    eTexture:build(200, 15)

    self.eBox = eTexture
end

function CSelectBoxElem:set_text_options(rgsTextList, iWidth)
    self:_set_text_options(rgsTextList)
    self:_load_selectbox_texts(iWidth)
    self:_reset_visible_position()
    self:_build_selectbox_texture()
end

function CSelectBoxElem:get_text_selected()
    local m_rgpTxtOpts = self.rgpTxtOpts
    return self:get_opt() ~= nil and m_rgpTxtOpts[self:get_opt()] or nil
end

function CSelectBoxElem:_set_text_selected(iOpt, bOptSlct)
    local m_rgpTxtOpts = self.rgpTxtOpts

    local pTxtSlct = table.remove(m_rgpTxtOpts, iOpt)
    if pTxtSlct ~= nil then
        self:_free_selectbox_text(pTxtSlct)
    end

    local sText = m_rgpTxtOpts[iOpt]
    local iWidth = RSelectbox.VW_SELECTBOX.LINE_W

    local pFontOpt = ctPoolFont:take_font(RWndPath.LOVE_FONT_DIR_PATH .. "arial.ttf", 12)

    local pTxtOpt = self:_load_selectbox_text(pFontOpt, sText, iWidth, bOptSlct)
    table.insert(m_rgpTxtOpts, iOpt, pTxtOpt)
end

function CSelectBoxElem:set_select_option(iOpt)
    local iCurOpt = self:get_opt()
    self:_set_opt(iOpt)

    if iCurOpt ~= nil then
        self:_set_text_selected(iCurOpt, false)
    end

    self:_set_text_selected(iOpt, true)
end

function CSelectBoxElem:load(sSelectBoxState, rX, rY)
    self.eElem:load(rX, rY)
    self:_load_selectbox_texture(sSelectBoxState)
end

function CSelectBoxElem:update(dt)
    -- do nothing
end

function CSelectBoxElem:draw()
    draw_selectbox(self)
end

function CSelectBoxElem:onmousehoverin()
    -- do nothing
end

function CSelectBoxElem:onmousehoverout()
    -- do nothing
end

function CSelectBoxElem:onmousereleased(x, y, button)
    local pBox = self:get_cover_box()
    local iLx, iTy, _, _ = pBox:get_ltrb()

    local iPy = y - iTy
    local iSgmt = math.floor(iPy / RSelectbox.VW_SELECTBOX.LINE_H)
    self:set_select_option(iSgmt)
end
