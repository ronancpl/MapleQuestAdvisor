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

CBasicImage = createClass({
    pImg,
    iOx,
    iOy,
    iZ
})

function CBasicImage:get_img()
    return self.pImg
end

function CBasicImage:get_origin()
    return self.iOx, self.iOy
end

function CBasicImage:get_z()
    return self.iZ
end

function CBasicImage:load(pImg, iOx, iOy, iZ)
    self.pImg = pImg
    self.iOx = iOx
    self.iOy = iOy
    self.iZ = iZ
end

function CBasicImage:instantiate(pWmapProp, bFlipOrigin)
    local pImg = CBasicImage:new()

    local iCx
    local iCy
    iCx, iCy = pWmapProp:get_origin()

    if bFlipOrigin then
        pImg:load(self.pImg, iCx - self.iOx, iCy - self.iOy, self.iZ)
    else
        pImg:load(self.pImg, iCx + self.iOx, iCy + self.iOy, self.iZ)
    end

    return pImg
end
