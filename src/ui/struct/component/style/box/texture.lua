--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("ui.run.draw.box.texture")
require("utils.struct.class")

CStyleBox = createClass({
    pImgBox,
    rgpImgBoxPos,

    pBoxArea,
    rgpBoxQuads,
    pBoxGrowth
})

function CStyleBox:_get_style_params(pImgBox, iIx, iIy, iIw, iIh, iOx, iOy, iOw, iOh)
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

function CStyleBox:_get_style_ltrb(iIx, iIy, iIw, iIh, iOx, iOy, iOw, iOh)
    local iL, iT, iR, iB

    iL = iIx
    iT = iIy

    iR = math.min(iL + iIw, iOx + iOw)
    iB = math.min(iT + iIh, iOy + iOh)

    return iL, iT, iR, iB
end

function CStyleBox:_init_params(pImgBox, iIx, iIy, iIw, iIh, iOx, iOy, iOw, iOh)
    local iIx, iIy, iIw, iIh, iOx, iOy, iOw, iOh = self:_get_style_params(pImgBox, iIx, iIy, iIw, iIh, iOx, iOy, iOw, iOh)

    local iL, iT, iR, iB = self:_get_style_ltrb(iIx, iIy, iIw, iIh, iOx, iOy, iOw, iOh)
    return iL, iT, iR, iB
end

function CStyleBox:load(pImgBox, iIx, iIy, iIw, iIh, iOx, iOy, iOw, iOh)
    local iL, iT, iR, iB = self:_init_params(pImgBox, iIx, iIy, iIw, iIh, iOx, iOy, iOw, iOh)
    local rgpImgBoxPos = load_texture_split(pImgBox, iL, iT, iR, iB)

    self.pImgBox = pImgBox
    self.rgpImgBoxPos = rgpImgBoxPos
end

function CStyleBox:build(iWidth, iHeight)
    self.pBoxArea = {iWidth, iHeight}
    self.rgpBoxQuads, self.pBoxGrowth = build_pattern_box(self.pImgBox, self.rgpImgBoxPos, iWidth, iHeight)
end

function CStyleBox:draw(iPx, iPy)
    local iWidth
    local iHeight
    iWidth, iHeight = unpack(self.pBoxArea)

    draw_texture_box(self.pImgBox, self.rgpBoxQuads, self.pBoxGrowth, iWidth, iHeight, iPx, iPy)
end
