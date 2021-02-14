--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("ui.struct.component.basic.image")
require("utils.struct.class")

CBasicQuad = createClass({
    eImg = CBasicImage:new(),
    iDelay
})

function CBasicQuad:get_delay()
    return self.iDelay
end

function CBasicQuad:load(pImg, iOx, iOy, iZ, iDelay)
    self.eImg = CBasicImage:load(pImg, iOx, iOy, iZ)
    self.iDelay = iDelay
end
