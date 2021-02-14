--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("ui.struct.component.basic.base")
require("ui.struct.component.basic.image")
require("utils.struct.class")

CStaticElem = createClass({
    eBase = CBasicElem:new(),
    eImg = CBasicImage:new()
})

function CStaticElem:load(pImg, iOx, iOy, iZ, rX, rY)
    self.eBase:load(rX, rY)
    self.eImg:load(pImg, iOx, iOy, iZ)
end

function CStaticElem:update(dt)
    -- do nothing
end

function CStaticElem:draw()

end
