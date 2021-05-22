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
require("ui.constant.view.resource")
require("ui.struct.component.canvas.button.button")
require("ui.struct.window.frame.channel")
require("utils.struct.class")

CWndBase = createClass({
    pBtClose,
    pCtrlChannel = CWndChannel:new()
})

function CWndBase:_onmousemoved(x, y, dx, dy, istouch)
    self.pCtrlChannel:onmousemoved(x, y, dx, dy, istouch)
end

function CWndBase:_onmousepressed(x, y, button)
    self.pCtrlChannel:onmousepressed(x, y, button)
end

function CWndBase:_onmousereleased(x, y, button)
    self.pCtrlChannel:onmousereleased(x, y, button)
end

function CWndBase:_onwheelmoved(dx, dy)
    self.pCtrlChannel:onwheelmoved(dx, dy)
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

function CWndBase:_set_window_size(iWidth, iHeight)
    local pBtClose = self:get_bt_close()
    local pBtClsVwConf = pBtClose:get_conf()

    pBtClose:set_origin(iWidth - pBtClsVwConf.FIL_X, pBtClsVwConf.FIL_Y)
end

function CWndBase:_set_fn_trigger()
    local pBtClose = self:get_bt_close()
    pBtClose:set_fn_trigger(self.close, self)
end

function CWndBase:_load_bt_close(iWidth, iHeight, pBtClsVwConf)
    local pBtClose = CButtonElem:new()
    pBtClose:load(pBtClsVwConf)

    self.pBtClose = pBtClose

    local m_pCtrlChannel = self.pCtrlChannel
    m_pCtrlChannel:add_element(pBtClose)

    self:_set_window_size(iWidth, iHeight)
    self:_set_fn_trigger()
end

function CWndBase:_load_control_channel(iWidth, iHeight, pBtClsVwConf)
    self:_load_bt_close(iWidth, iHeight, pBtClsVwConf)
end

function CWndBase:_load(iWidth, iHeight, pBtClsVwConf)
    self:open()
    self:_load_control_channel(iWidth, iHeight, pBtClsVwConf)
end

function CWndBase:_update(dt)
    self.pCtrlChannel:update(dt)
end

function CWndBase:_draw()
    self.pCtrlChannel:draw()
end
