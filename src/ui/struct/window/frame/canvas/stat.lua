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
require("ui.struct.canvas.stat.layer.background")
require("ui.struct.canvas.stat.layer.info")
require("ui.struct.canvas.stat.properties")
require("ui.struct.component.canvas.canvas")
require("ui.struct.window.frame.canvas")
require("utils.struct.class")

CWndStat = createClass({CWndBase, {
    pCanvas = CWndCanvas:new(),
    pProp = CStatProperties:new()
}})

function CWndStat:get_properties()
    return self.pProp
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
    local pDirStatImgs = load_image_storage_from_wz_sub(RWndPath.INTF_UI_WND, "Stat")
    pDirStatImgs = select_images_from_storage(pDirStatImgs, {})

    local pImgBase = love.graphics.newImage(find_image_on_storage(pDirStatImgs, "backgrnd"))
    self.pProp:set_base_img(pImgBase)
end

function CWndStat:load()
    self:_load_background()
    self.pCanvas:load({CStatNavBackground, CStatNavText}) -- follows sequence: LLayer

    local iBx
    local iBy
    iBx, iBy = self.pProp:get_base_img():getDimensions()

    self:set_dimensions(iBx, iBy)
end

function CWndStat:update(dt)
    self.pCanvas:update(dt)
end

function CWndStat:draw()
    self.pCanvas:draw()
end

function CWndStat:get_layer(iLayer)
    return self.pCanvas:get_layer(iLayer)
end
