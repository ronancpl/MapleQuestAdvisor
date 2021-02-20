--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("ui.struct.component.basic.anima")
require("ui.struct.component.basic.base")
require("utils.struct.class")
require("utils.struct.queue")

CDynamicElem = createClass({
    eElem = CBasicElem:new(),
    eAnima = CBasicAnima:new(),
    iTimer,
    pCurQuad,
    pQueueDrawingQuads
})

function CDynamicElem:load(rX, rY)
    local m_eElem = self.eElem
    m_eElem:load(rX, rY)

    local m_eAnima = self.eAnima
    m_eAnima:load()
    m_eAnima:update_quad()

    self.iTimer = 0.0
    self.pCurQuad = nil
    self.pQueueDrawingQuads = SQueue:new()
end

function CDynamicElem:_update_animation()
    local pQuad = m_eAnima:inspect_quad()

    while true do
        local iDelay = pQuad:get_delay()
        if self.iTimer < iDelay then
            break
        end

        self.iTimer = self.iTimer - iDelay

        m_eAnima:update_quad()
        pQuad = m_eAnima:inspect_quad()
        table.insert(rgpDrawingQuads, pQuad)
    end
end

function CDynamicElem:update(dt)
    self.iTimer = self.iTimer + dt
    self:_update_animation()
end

function CDynamicElem:_update_drawing()
    local pQuad = self.pQueueDrawingQuads:poll()
    if pQuad ~= nil then
        self.pCurQuad = pQuad
    else
        pQuad = self.pCurQuad
    end

    return pQuad:get_image()
end

function CDynamicElem:draw()
    local pImg = self:_update_drawing()

    local m_eElem = self.eElem
    local iPx, iPy = m_eElem:get_pos()

    local iOx, iOy = pImg:get_origin()
    love.graphics.draw{drawable=pImg:get_img(),x=iPx+iOx,y=iPy+iOy}
end
