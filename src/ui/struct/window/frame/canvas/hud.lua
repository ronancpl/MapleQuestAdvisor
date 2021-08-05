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
require("ui.constant.config")
require("ui.constant.view.button")
require("ui.run.build.interface.storage.basic.image")
require("ui.run.build.interface.storage.split")
require("ui.run.control.route")
require("ui.run.update.canvas.position")
require("ui.run.update.track.quest")
require("ui.struct.component.canvas.window.button")
require("ui.struct.component.canvas.window.state")
require("ui.struct.window.type")
require("ui.struct.window.element.basic.selectbox")
require("ui.struct.window.frame.channel")
require("ui.texture.composition")
require("utils.struct.class")

CWndHud = createClass({
    bHover = false,

    btGo,
    btSave,
    btLoad,
    btDelete,

    btUiInvt,
    btUiRscs,
    btUiStat,

    btNavNext,
    btNavPrev,
    pNavCurQuest,
    pSlctNavQuest,

    sFont = RWndPath.LOVE_FONT_DIR_PATH .. "amaranthbd.ttf",
    iFontHeight = 25,

    iFontOngoingHeight,
    iFontOngoingSize,
    pFontOngoingQuest,
    pTxtOngoingQuest,

    pBtChannel = CWndChannel:new(),
    pMiscChannel = CWndChannel:new()
})

function CWndHud:is_closed()
    return pWndHandler:is_closed(self)
end

function CWndHud:get_ltrb()
    return 0, 0, RWndConfig.WND_LIM_X, RWndConfig.WND_LIM_Y
end

function CWndHud:get_position()
    local iLx, iTy, _, _ = self:get_ltrb()
    return iLx, iTy
end

function CWndHud:get_text_height()
    return self.iFontOngoingHeight
end

function CWndHud:get_elements()
    local rgpItems = {}
    table_append(rgpItems, self.pBtChannel:get_elements())
    table_append(rgpItems, self.pMiscChannel:get_elements())

    return rgpItems
end

function CWndHud:has_mouse_hover()
    return self.bHover
end

function CWndHud:clear_mouse_hover()
    for _, pElem in ipairs(self.pBtChannel:get_elements()) do
        if pElem:get_state() ~= RButtonState.DISABLED then
            pElem:update_state(RButtonState.NORMAL)
        end
    end
    self.pSlctNavQuest:update_state(RSelectBoxState.NORMAL)

    self.bHover = false
end

function CWndHud:apply_mouse_hover()
    self.bHover = true
end

function CWndHud:_fn_bt_go(pPlayer)
    -- load quest route info
    tQuests = load_board_quests()
    pTrack, tRoute = run_route_bt_load(pPlayer)
end

function CWndHud:_load_bt_go(pPlayer)
    local bt = CButtonElem:new()
    bt:load(RActionButton.SEARCH.PATH, unpack(RActionButton.SEARCH.POSITION))
    bt:set_fn_trigger(self._fn_bt_go, {self, pPlayer})

    self.btGo = bt
    self.pBtChannel:add_element(bt)
end

function CWndHud:_fn_bt_save(pPlayer, pUiStats, tRoute, tQuests)
    -- save environment info
    run_rates_bt_save(pUiStats)
    run_player_bt_save(pPlayer)

    -- save quest route info
    run_route_bt_save(pPlayer, pUiStats, tRoute)
    save_board_quests(tQuests)
end

function CWndHud:_load_bt_save(pPlayer, pUiStats, tRoute, tQuests)
    local bt = CButtonElem:new()

    bt:load(RActionButton.SAVE.PATH, unpack(RActionButton.SAVE.POSITION))
    bt:set_fn_trigger(self._fn_bt_save, {self, pPlayer, pUiStats, tRoute, tQuests})

    self.btSave = bt
    self.pBtChannel:add_element(bt)
end

function CWndHud:_fn_bt_load(pUiStats, pPlayer)
    -- load environment info
    run_rates_bt_load(pUiStats, pPlayer)
    run_player_bt_load(pPlayer)
end

function CWndHud:_load_bt_load(pUiStats, pPlayer)
    local bt = CButtonElem:new()

    bt:load(RActionButton.OPEN.PATH, unpack(RActionButton.OPEN.POSITION))
    bt:set_fn_trigger(self._fn_bt_load, {self, pUiStats, pPlayer})

    self.btLoad = bt
    self.pBtChannel:add_element(bt)
end

function CWndHud:_fn_delete(pUiStats, pPlayer)
    -- delete environment info
    run_rates_bt_delete(pUiStats)
    run_player_bt_delete(pPlayer)

    -- delete quest route info
    run_route_bt_delete()
end

function CWndHud:_load_bt_delete(pUiStats, pPlayer)
    local bt = CButtonElem:new()

    bt:load(RActionButton.DELETE.PATH, unpack(RActionButton.DELETE.POSITION))
    bt:set_fn_trigger(self._fn_delete, {self, pUiStats, pPlayer})

    self.btDelete = bt
    self.pBtChannel:add_element(bt)
end

function CWndHud:get_buttons_route()
    return self.btGo, self.btSave, self.btLoad, self.btDelete
end

function CWndHud:_fn_wnd_toggle_open(pUiWnd)
    if pUiWnd:is_closed() then
        pUiWnd:reopen()
    else
        pUiWnd:close()
    end
end

function CWndHud:_load_bt_wnd_inventory()
    local bt = CButtonElem:new()

    bt:load(RActionButton.WND_INVT.PATH, unpack(RActionButton.WND_INVT.POSITION))
    bt:set_fn_trigger(self._fn_wnd_toggle_open, {self, pUiInvt})

    self.btUiInvt = bt
    self.pBtChannel:add_element(bt)
end

function CWndHud:_load_bt_wnd_resources()
    local bt = CButtonElem:new()

    bt:load(RActionButton.WND_RSCT.PATH, unpack(RActionButton.WND_RSCT.POSITION))
    bt:set_fn_trigger(self._fn_wnd_toggle_open, {self, pUiRscs})

    self.btUiRscs = bt
    self.pBtChannel:add_element(bt)
end

function CWndHud:_load_bt_wnd_stat()
    local bt = CButtonElem:new()

    bt:load(RActionButton.WND_STAT.PATH, unpack(RActionButton.WND_STAT.POSITION))
    bt:set_fn_trigger(self._fn_wnd_toggle_open, {self, pUiStats})

    self.btUiStat = bt
    self.pBtChannel:add_element(bt)
end

function CWndHud:_load_bt_nav_next(pTrack, pPlayer, tQuests, pUiWmap, pUiStats, pUiInvt, pPlayer, pIvtItems, pPlayer, siExpRate, siMesoRate, siDropRate, sWmapName, pUiRscs)
    local bt = CButtonElem:new()

    bt:load(RActionButton.NAV_NEXT.PATH, unpack(RActionButton.NAV_NEXT.POSITION))
    bt:set_fn_trigger(fn_bt_nav_next, {self, pTrack, pPlayer, tQuests, pUiWmap, pUiStats, pUiInvt, pPlayer, pIvtItems, pPlayer, siExpRate, siMesoRate, siDropRate, sWmapName, pUiRscs})

    self.btNavNext = bt
    self.pBtChannel:add_element(bt)
end

function CWndHud:_load_bt_nav_prev(pTrack, pPlayer, tQuests, pUiWmap, pUiStats, pUiInvt, pPlayer, pIvtItems, pPlayer, siExpRate, siMesoRate, siDropRate, sWmapName, pUiRscs)
    local bt = CButtonElem:new()

    bt:load(RActionButton.NAV_PREV.PATH, unpack(RActionButton.NAV_PREV.POSITION))
    bt:set_fn_trigger(fn_bt_nav_prev, {self, pTrack, pPlayer, tQuests, pUiWmap, pUiStats, pUiInvt, pPlayer, pIvtItems, pPlayer, siExpRate, siMesoRate, siDropRate, sWmapName, pUiRscs})

    self.btNavPrev = bt
    self.pBtChannel:add_element(bt)
end

function CWndHud:_load_sb_nav_select_quest()
    local pSlct = CSelectBoxElem:new()
    pSlct:load(RSelectBoxState.NORMAL, unpack(RActionElement.NAV_NEXT_QUEST.POSITION))

    self.pSlctNavQuest = pSlct
    self.pMiscChannel:add_element(pSlct)
end

function CWndHud:get_nav_select_quest()
    return self.pSlctNavQuest
end

function CWndHud:_load_texture_ongoing_quest()
    local pDirRscImgs = load_image_storage_from_wz_sub(RWndPath.INTF_UI_WND, "Title")
    pDirRscImgs = select_images_from_storage(pDirRscImgs, {})

    local rgpImgBox = {}
    table.insert(rgpImgBox, love.graphics.newImage(find_image_on_storage(pDirRscImgs, "backgrnd2")))

    local pImgBox, iIx, iIy, iIw, iIh, iOx, iOy, iOw, iOh = compose_texture_from_imageset(rgpImgBox, 1, 15, 15)

    local pBgrdData = CBasicTexture:new()
    pBgrdData:load(pImgBox, iIx, iIy, iIw, iIh, iOx, iOy, iOw, iOh)

    return pBgrdData
end

function CWndHud:_load_nav_player_background()
    local pTextureData = self:_load_texture_ongoing_quest()
    local pImgBox, iIx, iIy, iIw, iIh, iOx, iOy, iOw, iOh = pTextureData:get()

    local iTx, iTy = unpack(RActionElement.NAV_QUEST.POSITION)

    local eTexture = CTextureElem:new()
    eTexture:load(iTx, iTy, pImgBox, iIx, iIy, iIw, iIh, iOx, iOy, iOw, iOh)
    eTexture:build(254, 46)

    self.pNavOngoingQuest = eTexture
end

function CWndHud:_take_font_nav_player(sOngoingQuest)
    local sFont = self.sFont
    local iSize = self.iFontHeight

    local pFont
    while true do
        local rgsTextWrap

        pFont = ctPoolFont:take_font(sFont, iSize)
        _, rgsTextWrap = pFont:getWrap(sOngoingQuest, RActionElement.NAV_QUEST.LINE_WIDTH)

        if #rgsTextWrap < 2 or iSize < 15 then
            self.iFontOngoingHeight = #rgsTextWrap * pFont:getHeight(sText)
            break
        end

        ctPoolFont:put_font(pFont, sFont, iSize)
        iSize = iSize - 5
    end

    self.iFontOngoingSize = iSize

    return pFont
end

function CWndHud:_load_nav_player_text(iQuestid)
    local sOngoingQuest = iQuestid ~= nil and ctQuestsMeta:get_text(iQuestid) or "-"

    self.pFontOngoingQuest = self:_take_font_nav_player(sOngoingQuest)
    self.pTxtOngoingQuest = ctPoolFont:take_text(self.pFontOngoingQuest)

    self.pTxtOngoingQuest:setf({{0, 0, 0}, sOngoingQuest}, RActionElement.NAV_QUEST.LINE_WIDTH, "center")
end

function CWndHud:_free_nav_player_text()
    if self.pFontOngoingQuest ~= nil then
        if self.pTxtOngoingQuest ~= nil then
            ctPoolFont:put_text(self.pFontOngoingQuest, self.pTxtOngoingQuest)
            self.pTxtOngoingQuest = nil
        end

        ctPoolFont:put_font(self.pFontOngoingQuest, self.sFont, self.iFontOngoingSize)
        self.pFontOngoingQuest = nil
    end
end

function CWndHud:_load_nav_player_quest(iQuestid)
    self:_free_nav_player_text()

    self:_load_nav_player_background()
    self:_load_nav_player_text(iQuestid)
end

function CWndHud:get_nav_ongoing_quest()
    return self.pNavOngoingQuest
end

function CWndHud:draw_player_quest()
    local iPx, iPy = unpack(RActionElement.NAV_QUEST.POSITION)
    self.pNavOngoingQuest:draw(iPx, iPy)

    love.graphics.draw(self.pTxtOngoingQuest, iPx, iPy - math.floor(math.max((self:get_text_height() - 46) / 2), 0))

    local iNx, iNy = unpack(RActionElement.NAV_NEXT_QUEST.POSITION)
    self.pSlctNavQuest:draw(iNx, iNy)
end

function CWndHud:set_player_quest(pTrack)
    local pQuestProp = pTrack:get_top_quest()
    self:_load_nav_player_quest(pQuestProp ~= nil and pQuestProp:get_quest_id() or nil)
end

function CWndHud:load(pPlayer, pUiStats, pTrack, tRoute, tQuests, pUiWmap, pUiStats, pUiInvt, pPlayer, pIvtItems, pPlayer, siExpRate, siMesoRate, siDropRate, sWmapName, pUiRscs)
    self:_load_bt_go(pPlayer)
    self:_load_bt_save(pPlayer, pUiStats, tRoute, tQuests)
    self:_load_bt_load(pUiStats, pPlayer)
    self:_load_bt_delete(pUiStats, pPlayer)

    self:_load_bt_wnd_inventory()
    self:_load_bt_wnd_resources()
    self:_load_bt_wnd_stat()

    self:_load_bt_nav_next(pTrack, pPlayer, tQuests, pUiWmap, pUiStats, pUiInvt, pPlayer, pIvtItems, pPlayer, siExpRate, siMesoRate, siDropRate, sWmapName, pUiRscs)
    self:_load_bt_nav_prev(pTrack, pPlayer, tQuests, pUiWmap, pUiStats, pUiInvt, pPlayer, pIvtItems, pPlayer, siExpRate, siMesoRate, siDropRate, sWmapName, pUiRscs)
    self:_load_sb_nav_select_quest()

    self:set_player_quest(pTrack)
end

function CWndHud:update(dt)
    self.pBtChannel:update(dt)
end

function CWndHud:draw()
    self.pBtChannel:draw()
    self:draw_player_quest()
end

function CWndHud:_fetch_relative_pos(x, y)
    local iPx, iPy = 0, 0
    return x - iPx, y - iPy
end

function CWndHud:get_misc_channel()
    return self.pMiscChannel
end

function CWndHud:onmousemoved(x, y, dx, dy, istouch)
    self.pBtChannel:onmousemoved(x, y, dx, dy, istouch)
    self.pMiscChannel:onmousemoved(x, y, dx, dy, istouch)
end

function CWndHud:onmousereleased(x, y, button)
    self.pBtChannel:onmousereleased(x, y, button)
    self.pMiscChannel:onmousereleased(x, y, button)
end

function CWndHud:hide_elements()
    -- do nothing
end
