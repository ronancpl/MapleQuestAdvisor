--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("composer.field.node.media.image")
require("ui.run.draw.canvas.style.texture")
require("ui.run.load.interface.image")
require("ui.struct.component.basic.base")
require("ui.struct.component.basic.texture")
require("ui.struct.window.summary")
require("utils.struct.class")

CTextureElem = createClass({
    eElem = CBasicElem:new(),
    eImg = CBasicOutline:new(),

    pCanvas,
    bReady,

    pImgBox,
    rgpImgBoxPos,

    pBoxArea,
    rgpBoxQuads,
    pBoxGrowth
})

function CTextureElem:get_origin()
    return self.eElem:get_pos()
end

function CTextureElem:_load_position(iRx, iRy)
    self.eElem:load(iRx, iRy)
end

function CTextureElem:set_origin(iRx, iRy)
    self:_load_position(iRx, iRy)
end

function CTextureElem:get_z()
    return self.eImg:get_z()
end

function CTextureElem:get_ltrb()
    local m_eElem = self.eElem
    local iPx, iPy = m_eElem:get_pos()

    local iLx, iTy, iRx, iBy = self.eImg:get_ltrb()
    return iLx + iPx, iTy + iPy, iRx + iPx, iBy + iPy
end

function CTextureElem:get_dimensions()
    local iWidth
    local iHeight
    iWidth, iHeight = unpack(self.pBoxArea)

    return iWidth, iHeight
end

function CTextureElem:get_texture()
    return self.pImgBox
end

function CTextureElem:_get_limit_params(pImgBox, iIx, iIy, iIw, iIh, iOx, iOy, iOw, iOh)
    local iWidth
    local iHeight
    iWidth, iHeight = pImgBox:getDimensions()

    local iIx = iIx or 0
    local iIy = iIy or 0
    local iIw = iIw or iWidth
    local iIh = iIh or iHeight
    local iOx = iOx or 0
    local iOy = iOy or 0
    local iOw = iOw or iWidth
    local iOh = iOh or iHeight

    return iIx, iIy, iIw, iIh, iOx, iOy, iOw, iOh
end

function CTextureElem:_get_limit_ltrb(iIx, iIy, iIw, iIh, iOx, iOy, iOw, iOh)
    local iL, iT, iR, iB

    iL = iIx
    iT = iIy

    iR = math.min(iL + iIw, iOx + iOw)
    iB = math.min(iT + iIh, iOy + iOh)

    return iL, iT, iR, iB
end

function CTextureElem:_init_params(pImgBox, iIx, iIy, iIw, iIh, iOx, iOy, iOw, iOh)
    local iL, iT, iR, iB = self:_get_limit_ltrb(iIx, iIy, iIw, iIh, iOx, iOy, iOw, iOh)
    return iL, iT, iR, iB
end

function CTextureElem:_load_texture(pImgBox, iIx, iIy, iIw, iIh, iOx, iOy, iOw, iOh)
    iIx, iIy, iIw, iIh, iOx, iOy, iOw, iOh = self:_get_limit_params(pImgBox, iIx, iIy, iIw, iIh, iOx, iOy, iOw, iOh)

    local iL, iT, iR, iB = self:_init_params(pImgBox, iIx, iIy, iIw, iIh, iOx, iOy, iOw, iOh)
    local rgpImgBoxPos = load_texture_split(pImgBox, iL, iT, iR, iB)

    self.pImgBox = pImgBox
    self.rgpImgBoxPos = rgpImgBoxPos
    self.eImg:load(0, 0, -1, iOw, iOh)
end

function CTextureElem:load(iRx, iRy, pImgBox, iIx, iIy, iIw, iIh, iOx, iOy, iOw, iOh)
    if pImgBox == nil then
        local pImgData = load_image_empty()
        pImgBox = love.graphics.newImage(pImgData)
    end

    self:_load_position(iRx, iRy)
    self:_load_texture(pImgBox, iIx, iIy, iIw, iIh, iOx, iOy, iOw, iOh)
end

function CTextureElem:_prepare_canvas()
    local iWidth
    local iHeight
    iWidth, iHeight = self:get_dimensions()

    self.pCanvas = love.graphics.newCanvas()
    draw_canvas_texture_box(self.pCanvas, self.pImgBox, self.rgpBoxQuads, self.pBoxGrowth, iWidth, iHeight)
end

function CTextureElem:build(iWidth, iHeight)
    self.eImg:load(0, 0, LChannel.OVR_TEXTURE, iWidth, iHeight)

    self.pBoxArea = {iWidth, iHeight}
    self.rgpBoxQuads, self.pBoxGrowth = build_pattern_box(self.pImgBox, self.rgpImgBoxPos, iWidth, iHeight)

    self:_prepare_canvas()
    self.bReady = true
end

function CTextureElem:unbuild()
    self.bReady = false
    self.pCanvas = nil
end

function CTextureElem:is_ready()
    return self.bReady
end

function CTextureElem:update(dt)
    -- do nothing
end

function CTextureElem:draw(iPx, iPy, iR)
    draw_texture_box(self.pCanvas, iPx, iPy, iR)
end
