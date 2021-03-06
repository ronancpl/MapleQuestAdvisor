--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

function make_subimage(pImg, iX, iY, iW, iH)
    local pCanvas = love.graphics.newCanvas(3 * iW, 3 * iH)

    pCanvas:renderTo(function()
        love.graphics.clear()

        love.graphics.setScissor(0, 0, iW - iX, iH - iY)
        love.graphics.draw(pImg, -iX, -iY)
    end)

    local pImgData = pCanvas:newImageData(0, 1, 0, 0, iW - iX, iH - iY)
    return love.graphics.newImage(pImgData)
end
