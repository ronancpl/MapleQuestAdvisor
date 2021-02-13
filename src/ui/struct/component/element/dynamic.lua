--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("ui.struct.component.basic.anima")
require("ui.struct.component.basic.base")
require("utils.struct.class")

CDynamicElem = createClass({
    eElem,
    eAnima
})

function CDynamicElem:load(rX, rY)
    self.eElem = CBasicElem:new(rX, rY)
    self.eAnima = CBasicAnima:new()
end

function CDynamicElem:update(dt)

end

function CDynamicElem:draw()

end
