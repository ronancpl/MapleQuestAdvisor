--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("ui.run.load.interface.image")
require("ui.struct.component.basic.base")
require("ui.struct.component.basic.image")
require("utils.struct.class")

CStaticElem = createClass({
    eElem = CBasicElem:new(),
    eImg = CBasicImage:new()
})

function CStaticElem:get_origin()
    return self.eImg:get_origin()
end

function CStaticElem:get_z()
    return self.eImg:get_z()
end

function CStaticElem:get_ltrb()
    local m_eElem = self.eElem
    local iPx, iPy = m_eElem:get_pos()

    local m_eImg = self.eImg
    local iOx, iOy = m_eImg:get_origin()

    local pImg = m_eImg:get_img()
    local iW = pImg:getWidth()
    local iH = pImg:getHeight()

    local iLx = iOx + iPx
    local iTy = iOy + iPy

    local iRx = iLx + iW
    local iBy = iTy + iH

    return iLx, iTy, iRx, iBy
end

function CStaticElem:get_center()
    local iLx, iTy, iRx, iBy = self.eImg:get_ltrb()
    return (iLx + iRx) / 2, (iTy + iBy) / 2
end

function CStaticElem:load(pImg, iOx, iOy, iZ, rX, rY)
    self.eElem:load(rX, rY)
    self.eImg:load(pImg, iOx, iOy, iZ)
end

function CStaticElem:instantiate(pWmapProp, bFlipOrig)
    self.eImg = instantiate_image(pWmapProp, self.eImg, bFlipOrig)
end

function CStaticElem:update(dt)
    -- do nothing
end

function CStaticElem:draw()
    local m_eElem = self.eElem
    local iPx, iPy = m_eElem:get_pos()

    local m_eImg = self.eImg
    local iOx, iOy = m_eImg:get_origin()

    love.graphics.draw(m_eImg:get_img(), iPx+iOx, iPy+iOy)
end
