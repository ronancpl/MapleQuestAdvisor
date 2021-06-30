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
    pHdlWnd,

    iRx,
    iRy,
    iW,
    iH,

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

function CWndBase:grab_set_position(dx, dy)
    local iPx, iPy = self:get_position()
    local iWx, iWy = self:get_dimensions()

    self.iRx = math.iclamp(iPx + dx, 0, RWndConfig.WND_LIM_X - iWx)
    self.iRy = math.iclamp(iPy + dy, 0, RWndConfig.WND_LIM_Y - iWy)
end

function CWndBase:fetch_relative_pos(x, y)
    local iPx, iPy = self:get_position()
    return x - iPx, y - iPy
end

function CWndBase:_onmousemoved(x, y, dx, dy, istouch)
    self.pCtrlChannel:onmousemoved(x, y, dx, dy, istouch)
    self.pSureChannel:onmousemoved(x, y, dx, dy, istouch, true)
end

function CWndBase:_onmousepressed(x, y, button)
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

function CWndBase:is_closed()
    return pWndHandler:is_closed(self)
end

function CWndBase:close()
    pWndHandler:set_closed(self)
end

function CWndBase:open()
    pWndHandler:set_opened(self)
end

function CWndBase:get_bt_close()
    return self.pBtClose
end

function CWndBase:get_handle_pos()
    return self.pHdlWnd
end

function CWndBase:_set_window_size(iWidth, iHeight)
    local pBtClose = self:get_bt_close()
    local pBtClsVwConf = pBtClose:get_conf()

    pBtClose:set_origin(iWidth - pBtClsVwConf.FIL_X, pBtClsVwConf.FIL_Y)

    self:_set_dimensions(iWidth, iHeight)
end

function CWndBase:fn_close()
    return function()
        self:close()
    end
end

function CWndBase:_fn_set_position()
    return function(dx, dy)
        self:grab_set_position(dx, dy)
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
    pBtClose:load(pBtClsVwConf)

    self.pBtClose = pBtClose

    local m_pCtrlChannel = self.pCtrlChannel
    m_pCtrlChannel:add_element(pBtClose)

    self:_set_window_size(iWidth, iHeight)
    self:_set_fn_trigger_bt_close()
end

function CWndBase:_set_fn_trigger_pos_handle()
    local pHdlWnd = self:get_handle_pos()
    pHdlWnd:set_fn_trigger(self:_fn_set_position())
end

function CWndBase:_set_fn_trigger_reg_sure()
    local pHdlWnd = self:get_handle_pos()
    pHdlWnd:set_fn_reg_sure(self:_fn_register_sure())
end

function CWndBase:_set_fn_trigger_unreg_sure()
    local pHdlWnd = self:get_handle_pos()
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
