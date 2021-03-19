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

function CBasicImage:get_ltrb()
    local iW, iH = self:get_img():getDimensions()

    local iLx = self.iOx
    local iTy = self.iOy
    local iRx = self.iOx + iW
    local iBy = self.iOy + iH

    return iLx, iTy, iRx, iBy
end

function CBasicImage:load(pImg, iOx, iOy, iZ)
    self.pImg = pImg
    self.iOx = iOx
    self.iOy = iOy
    self.iZ = iZ
end

function CBasicImage:instantiate(pWmapProp, bFlipOrigin)
    local pBasicImg = CBasicImage:new()

    local iCx
    local iCy
    iCx, iCy = pWmapProp:get_origin()

    local pImg = love.graphics.newImage(self.pImg)
    if bFlipOrigin then
        pBasicImg:load(pImg, iCx - self.iOx, iCy - self.iOy, self.iZ)
    else
        pBasicImg:load(pImg, iCx + self.iOx, iCy + self.iOy, self.iZ)
    end

    return pBasicImg
end
