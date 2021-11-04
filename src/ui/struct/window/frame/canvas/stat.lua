--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("ui.struct.canvas.stat.properties")
require("ui.struct.canvas.stat.layer.background")
require("ui.struct.canvas.stat.layer.info")
require("ui.struct.component.canvas.canvas")
require("ui.struct.window.type")
require("ui.struct.window.frame.canvas")
require("utils.struct.class")

CWndStat = createClass({CWndBase, {
    pCanvas = CWndCanvas:new(),
    pProp = CStatProperties:new()
}})

function CWndStat:get_properties()
    return self.pProp
end

function CWndStat:get_window_position()
    return self:get_position()
end

function CWndStat:set_window_position(iRx, iRy)
    self:set_position(iRx, iRy)
end

function CWndStat:set_dimensions(iWidth, iHeight)
    self:_set_window_size(iWidth, iHeight)
end

function CWndStat:update_stats(pPlayer, siExpR, siMesoR, siDropR)
    self.pCanvas:reset()

    self.pProp:update_stats(pPlayer, siExpR, siMesoR, siDropR)
    self.pCanvas:build(self.pProp)
end

function CWndStat:_load_background()
    local pImgBase = ctPoolImg:take_image("", "Stat.backgrnd")
    self.pProp:set_base_img(pImgBase)
end

function CWndStat:load()
    self:_load_background()

    local iWidth
    local iHeight
    iWidth, iHeight = self.pProp:get_base_img():getDimensions()

    self:_load(iWidth, iHeight, RWndBtClose.TYPE2)
    self:set_dimensions(iWidth, iHeight)

    self.pCanvas:load({CStatNavBackground, CStatNavText}) -- follows sequence: LLayer
end

function CWndStat:update(dt)
    self:_update(dt)
    self.pCanvas:update(dt)
end

function CWndStat:draw()
    local iRx, iRy = self:get_window_position()

    push_stack_canvas_position(iRx, iRy)
    self.pCanvas:draw()
    pop_stack_canvas_position()

    self:_draw()
end

function CWndStat:onmousemoved(x, y, dx, dy, istouch)
    self:_onmousemoved(x, y, dx, dy, istouch)
    self.pCanvas:onmousemoved(x, y, dx, dy, istouch)
end

function CWndStat:onmousepressed(x, y, button)
    self:_onmousepressed(x, y, button)
    self.pCanvas:onmousepressed(x, y, button)
end

function CWndStat:onmousereleased(x, y, button)
    self:_onmousereleased(x, y, button)
    self.pCanvas:onmousereleased(x, y, button)
end

function CWndStat:onwheelmoved(dx, dy)
    self:_onwheelmoved(dx, dy)
    self.pCanvas:onwheelmoved(dx, dy)
end

function CWndStat:hide_elements()
    self:_hide_elements()
    self.pCanvas:hide_elements()
end

function CWndStat:get_layer(iLayer)
    return self.pCanvas:get_layer(iLayer)
end
