--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("router.filters.constant")
require("ui.path.textbox")
require("utils.struct.class")

CStyleLimit = createClass({
    iGrowth,
    iLineWidth,
    iHeight,

    iRx,
    iRy
})

function CStyleLimit:get_growth()
    return self.iGrowth
end

function CStyleLimit:get_width()
    return self.iLineWidth
end

function CStyleLimit:get_height()
    return self.iHeight
end

function CStyleLimit:reset()
    self.iGrowth = 0
    self.iLineWidth = RStylebox.MIN_X
    self.iHeight = 2 * RStylebox.UPD_Y
end

function CStyleLimit:increment()
    self.iGrowth = self.iGrowth + 1

    -- alternates in length expansion & new line
    if self.iGrowth % 2 == 0 and self.iLineWidth < RStylebox.MAX_X - (2 * RStylebox.FIL_X) then
        self.iLineWidth = self.iLineWidth + RStylebox.UPD_X
    else
        self.iHeight = self.iHeight + RStylebox.UPD_Y
    end
end

function CStyleLimit:update_box_position(iMx, iMy)
    local iBx = self:get_width()
    local iBy = self:get_height()

    self.iRx = math.iclamp(iMx - iBx / 2, 0, RStylebox.WND_LIM_X - iBx)
    self.iRy = math.iclamp(iMy - iBy / 2, 0, RStylebox.WND_LIM_Y - iBy)
end

function CStyleLimit:get_box_position()
    return self.iRx, self.iRy
end
