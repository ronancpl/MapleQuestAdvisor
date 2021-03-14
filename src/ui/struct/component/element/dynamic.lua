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

function CDynamicElem:load(rX, rY, rgpQuads)
    local m_eElem = self.eElem
    m_eElem:load(rX, rY)

    local m_eAnima = self.eAnima
    m_eAnima:load(rgpQuads)
end

function CDynamicElem:get_image()
    return self.pCurQuad:get_image()
end

function CDynamicElem:instantiate(pWmapProp, bFlipOrig)
    local m_eAnima = self.eAnima

    local rgpQuads = instantiate_quads(pWmapProp, m_eAnima:get_quads(), bFlipOrig)
    m_eAnima:load(rgpQuads)
end

function CDynamicElem:after_load()
    local m_eAnima = self.eAnima
    m_eAnima:update_quad()

    local rgpQuads = m_eAnima:get_quads()

    self.iTimer = 0.0
    self.pCurQuad = rgpQuads[1]
    self.pQueueDrawingQuads = SQueue:new()
end

function CDynamicElem:_update_animation()
    local m_eAnima = self.eAnima
    local pQuad = m_eAnima:inspect_quad()

    local m_pQueueDrawingQuads = self.pQueueDrawingQuads

    while true do
        local iDelay = pQuad:get_delay()
        if self.iTimer < iDelay then
            break
        end

        self.iTimer = self.iTimer - iDelay

        m_eAnima:update_quad()
        pQuad = m_eAnima:inspect_quad()
        m_pQueueDrawingQuads:push(pQuad)
    end
end

function CDynamicElem:update(dt)
    self.iTimer = self.iTimer + dt
    self:_update_animation()
end

function CDynamicElem:update_drawing()
    local pQuad = self.pQueueDrawingQuads:poll()
    if pQuad ~= nil then
        self.pCurQuad = pQuad
    else
        pQuad = self.pCurQuad
    end

    return pQuad:get_image()
end

function CDynamicElem:draw()
    local pImg = self:update_drawing()

    local m_eElem = self.eElem
    local iPx, iPy = m_eElem:get_pos()

    local iOx, iOy = pImg:get_origin()
    love.graphics.draw(pImg:get_img(), iPx+iOx, iPy+iOy)
end
