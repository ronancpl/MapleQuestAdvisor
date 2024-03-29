--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("ui.constant.config")
require("ui.constant.path")
require("ui.constant.view.resource")
require("ui.run.update.canvas.position")
require("ui.struct.component.canvas.window.button")
require("ui.struct.component.canvas.window.handle")
require("ui.struct.window.frame.channel")
require("utils.struct.class")

CWndBase = createClass({
    pBtClose,
    pBtClsVwConf,
    pHdlWnd,

    iRx,
    iRy,
    iW,
    iH,

    iMx = 0,
    iMy = 0,

    pCtrlChannel = CWndChannel:new(),
    pSureChannel = CWndChannel:new()    -- for in-elements interactions only
})

function CWndBase:get_position()
    return self.iRx, self.iRy
end

function CWndBase:set_position(iRx, iRy)
    self.iRx = iRx
    self.iRy = iRy
end

function CWndBase:get_dimensions()
    return self.iW, self.iH
end

function CWndBase:_set_dimensions(iWidth, iHeight)
    self.iW = iWidth
    self.iH = iHeight
end

function CWndBase:fetch_relative_pos(x, y)
    local iPx, iPy = self:get_position()
    return x - iPx, y - iPy
end

function CWndBase:grab_set_position(x, y)
    if pWndHandler:is_focus_wnd(self) then
        local iWx, iWy = self:get_dimensions()

        local iRx = math.iclamp(x - self.iMx, 0, RWndConfig.WND_LIM_X - iWx)
        local iRy = math.iclamp(y - self.iMy, 0, RWndConfig.WND_LIM_Y - iWy)
        self:set_position(iRx, iRy)
    end
end

function CWndBase:get_ltrb()
    local iRx, iRy = self:get_position()
    local iW, iH = self:get_dimensions()

    return iRx, iRy, iRx + iW, iRy + iH
end

function CWndBase:_onmousemoved(x, y, dx, dy, istouch)
    self.pCtrlChannel:onmousemoved(x, y, dx, dy, istouch)
    self.pSureChannel:onmousemoved(x, y, dx, dy, istouch, true)
end

function CWndBase:_onmousepressed(x, y, button)
    self.iMx, self.iMy = x, y

    self.pCtrlChannel:onmousepressed(x, y, button)
    self.pSureChannel:onmousepressed(x, y, button, true)
end

function CWndBase:_onmousereleased(x, y, button)
    self.pCtrlChannel:onmousereleased(x, y, button)
    self.pSureChannel:onmousereleased(x, y, button, true)
end

function CWndBase:_onwheelmoved(dx, dy)
    self.pCtrlChannel:onwheelmoved(dx, dy)
    self.pSureChannel:onwheelmoved(dx, dy, true)
end

function CWndBase:_hide_elements()
    self.pCtrlChannel:hide_elements()
    self.pSureChannel:hide_elements()
end

function CWndBase:is_closed()
    return pWndHandler:is_closed(self)
end

function CWndBase:close()
    pWndHandler:set_closed(self)
end

function CWndBase:open()
    --pWndHandler:set_opened(self)
end

function CWndBase:reopen()
    pWndHandler:set_opened(self)
end

function CWndBase:get_bt_close()
    return self.pBtClose
end

function CWndBase:get_wnd_handle()
    return self.pHdlWnd
end

function CWndBase:_set_window_size(iWidth, iHeight)
    local pBtClose = self:get_bt_close()

    local rX, rY = unpack(self.pBtClsVwConf)
    pBtClose:set_origin(iWidth + rX, rY)

    self:_set_dimensions(iWidth, iHeight)
end

function CWndBase:fn_close()
    return function()
        self:close()
    end
end

function CWndBase:_fn_set_position()
    return function(x, y)
        self:grab_set_position(x, y)
    end
end

function CWndBase:_fn_register_sure()
    return function(pElem)
        self.pSureChannel:add_element(pElem)
    end
end

function CWndBase:_fn_unregister_sure()
    return function(pElem)
        self.pSureChannel:remove_element(pElem)
    end
end

function CWndBase:_set_fn_trigger_bt_close()
    local pBtClose = self:get_bt_close()
    pBtClose:set_fn_trigger(self:fn_close())
end

function CWndBase:_load_bt_close(iWidth, iHeight, pBtClsVwConf)
    local pBtClose = CButtonElem:new()

    self.pBtClsVwConf = pBtClsVwConf
    pBtClose:load("BtClose", U_INT_MIN, U_INT_MIN)

    self.pBtClose = pBtClose

    local m_pCtrlChannel = self.pCtrlChannel
    m_pCtrlChannel:add_element(pBtClose)

    self:_set_window_size(iWidth, iHeight)
    self:_set_fn_trigger_bt_close()
end

function CWndBase:_set_fn_trigger_pos_handle()
    local pHdlWnd = self:get_wnd_handle()
    pHdlWnd:set_fn_trigger(self:_fn_set_position())
end

function CWndBase:_set_fn_trigger_reg_sure()
    local pHdlWnd = self:get_wnd_handle()
    pHdlWnd:set_fn_reg_sure(self:_fn_register_sure())
end

function CWndBase:_set_fn_trigger_unreg_sure()
    local pHdlWnd = self:get_wnd_handle()
    pHdlWnd:set_fn_unreg_sure(self:_fn_unregister_sure())
end

function CWndBase:_load_hdl_pos(iWidth)
    local pHdlWnd = CHandleElem:new()
    pHdlWnd:load(0, 0, iWidth, RResourceTable.VW_WND.VW_HANDLE.H)
    self.pHdlWnd = pHdlWnd

    local m_pCtrlChannel = self.pCtrlChannel
    m_pCtrlChannel:add_element(pHdlWnd)

    self:_set_fn_trigger_pos_handle()
    self:_set_fn_trigger_reg_sure()
    self:_set_fn_trigger_unreg_sure()
end

function CWndBase:_load_control_channel(iWidth, iHeight, pBtClsVwConf)
    self:_load_bt_close(iWidth, iHeight, pBtClsVwConf)
    self:_load_hdl_pos(iWidth)
end

function CWndBase:_load(iWidth, iHeight, pBtClsVwConf)
    self:set_position(0, 0)
    self:_load_control_channel(iWidth, iHeight, pBtClsVwConf)
    self:open()
end

function CWndBase:_update(dt)
    self.pCtrlChannel:update(dt)
end

function CWndBase:_draw()
    local iRx, iRy = self:get_position()

    push_stack_canvas_position(iRx, iRy)
    self.pCtrlChannel:draw()
    pop_stack_canvas_position()
end
