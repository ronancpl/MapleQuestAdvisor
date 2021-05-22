--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("ui.struct.component.element.static")
require("utils.struct.class")

CStatElem = createClass({
    eConst = CStaticElem:new()
})

function CStatElem:get_object()
    return self.eConst
end

function CStatElem:load(pImg, iRx, iRy)
    self.eConst:load(pImg, 0, 0, 1, iRx, iRy)
end

function CStatElem:update(dt)
    -- do nothing
end

function CStatElem:draw()
    self.eConst:draw()
end
