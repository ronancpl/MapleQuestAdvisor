--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("utils.struct.class")

CBasicTexture = createClass({
    pImgBox,
    iIx, iIy, iIw, iIh,
    iOx, iOy, iOw, iOh
})

function CBasicTexture:load(pImgBox, iIx, iIy, iIw, iIh, iOx, iOy, iOw, iOh)
    self.pImgBox = pImgBox
    self.iIx = iIx
    self.iIy = iIy
    self.iIw = iIw
    self.iIh = iIh
    self.iOx = iOx
    self.iOy = iOy
    self.iOw = iOw
    self.iOh = iOh
end

function CBasicTexture:get()
    return self.pImgBox, self.iIx, self.iIy, self.iIw, self.iIh, self.iOx, self.iOy, self.iOw, self.iOh
end
