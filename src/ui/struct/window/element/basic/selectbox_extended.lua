--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("ui.struct.component.element.rect")
require("ui.struct.window.summary")
require("utils.struct.class")

CSelectBoxExtElem = createClass({
    eBox = CUserboxElem:new(),
    pLnkSlctBox
})

function CSelectBoxExtElem:get_object()
    return self.eBox
end

function CSelectBoxExtElem:reset()
    --self.pLnkSlctBox = nil
end

function CSelectBoxExtElem:get_ltrb()
    return self.eBox:get_ltrb()
end

function CSelectBoxExtElem:onmousereleased(x, y, button)
    local iLx, iTy, iRx, iBy = self:get_ltrb()

    if button == 1 then
        local iPy = y - iTy
        local iSgmt = math.floor(iPy / RSelectbox.VW_SELECTBOX.LINE_H) + 1

        self.pLnkSlctBox:set_select_option(iSgmt)
        self.pLnkSlctBox:clear_extended()
    end
end

function CSelectBoxExtElem:load(pLnkSlctBox, iPx, iPy, iW, iH)
    self.pLnkSlctBox = pLnkSlctBox
    pLnkSlctBox:set_extended(self)
    self.eBox:load(iPx, iPy, iW, iH)
end
