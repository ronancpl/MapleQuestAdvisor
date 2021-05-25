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
require("ui.constant.view.style")
require("utils.struct.class")

CStyleLimit = createClass({
    iGrowth,
    iLineWidth,
    iHeight,

    iRx = 0,
    iRy = 0,

    iImgDx,
    iImgDy
})

function CStyleLimit:get_growth()
    return self.iGrowth
end

function CStyleLimit:get_width()
    return self.iLineWidth
end

function CStyleLimit:set_width(iWidth)
    self.iLineWidth = iWidth
end

function CStyleLimit:get_height()
    return self.iHeight
end

function CStyleLimit:reset()
    self.iGrowth = 0
    self.iLineWidth = RStylebox.MIN_X - (2 * RStylebox.FIL_X)
    self.iHeight = 2 * RStylebox.UPD_Y
end

function CStyleLimit:increment()
    self.iGrowth = self.iGrowth + 1

    -- alternates in length expansion & new line
    if self.iGrowth % 2 == 0 and self.iLineWidth + RStylebox.UPD_X < RStylebox.MAX_X - (2 * RStylebox.FIL_X) then
        self.iLineWidth = self.iLineWidth + RStylebox.UPD_X
    else
        self.iHeight = self.iHeight + RStylebox.UPD_Y
    end
end

function CStyleLimit:trim(iBoxWidth)
    local iTdx, _ = self:get_image_dimensions()
    if iTdx == nil then
        iTdx = 0
    else
        iTdx = iTdx + RStylebox.FIL_X
    end

    local iWidth = iBoxWidth - iTdx - (2 * RStylebox.FIL_X)
    self:set_width(iWidth)
end

function CStyleLimit:update_box_position(iMx, iMy)
    local iIw, iIh = self:get_image_dimensions()

    local iBx = self:get_width() + (iIw and (iIw + RStylebox.FIL_X) or 0) + (2 * RStylebox.FIL_X)
    local iBy = math.max(self:get_height(), iIh or 0) - (2 * RStylebox.FIL_Y)

    self.iRx = math.iclamp(iMx + 20, 0, RWndConfig.WND_LIM_X - iBx)
    self.iRy = math.iclamp(iMy + 23, 0, RWndConfig.WND_LIM_Y - iBy)
end

function CStyleLimit:get_box_position()
    return self.iRx, self.iRy
end

function CStyleLimit:get_image_dimensions()
    return self.iImgDx, self.iImgDy
end

function CStyleLimit:set_image_dimensions(iWidth, iHeight)
    self.iImgDx = iWidth
    self.iImgDy = iHeight
end
