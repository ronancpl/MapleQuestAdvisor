--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("structs.field.worldmap.basic.spot")
require("utils.struct.class")

CWmapBasicSprite = createClass({CWmapBasicSpot, {
    iZ,
    iDelay
}})

function CWmapBasicSprite:get_z()
    return self.iZ
end

function CWmapBasicSprite:get_delay()
    return self.iDelay
end

function CWmapBasicSprite:get_image()
    return self.iOx, self.iOy
end

function CWmapBasicSprite:new(iOx, iOy, iZ, iDelay)
    self.iOx = iOx
    self.iOy = iOy
    self.iZ = iZ
    self.iDelay = iDelay
    return self
end
