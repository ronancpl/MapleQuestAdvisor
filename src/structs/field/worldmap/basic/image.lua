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

CWmapBasicImage = createClass({CWmapBasicSpot, {
    iZ
}})

function CWmapBasicImage:get_image()
    return self.iOx, self.iOy, self.iZ
end

function CWmapBasicImage:new(iOx, iOy, iZ)
    self.iOx = iOx
    self.iOy = iOy
    self.iZ = iZ
    return self
end
