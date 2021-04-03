--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("ui.run.draw.canvas.slider.slider")
require("utils.struct.class")

RSliderState = {DISABLED = "thumbDisabled", MOUSE_OVER = "thumbMouseOver", NORMAL = "thumbNormal", PRESSED = "thumbPressed"}

CWndSlider = createClass({
    iLength,     -- slider length
    eThumb,    -- moves freely inside slider

    iSgmtCur = 1,
    iSgmtCount = 1,

    bVert
})

function CWndSlider:get_bar_length()
    return self.iLength
end

function CWndSlider:get_thumb()
    return self.eThumb
end

function CWndSlider:get_thumb_length()
    local iWidth
    iWidth, _ = self.eThumb:get_dimensions()

    return iWidth
end

function CWndSlider:get_current()
    return self.iSgmtCur
end

function CWndSlider:set_current(iCur)
    self.iSgmtCur = iCur
end

function CWndSlider:get_split()
    return self.iSgmtCount
end

function CWndSlider:_set_split(iCount)
    self.iSgmtCount = iCount
end

function CWndSlider:get_orientation()
    return self.bVert
end

function CWndSlider:_set_orientation(bVert)
    self.bVert = bVert
end

function CWndSlider:_load_thumb(sThumbName)
    local eThumb = ctVwSlider:get_thumb(sThumbName)
    self.eThumb = eThumb
end

function CWndSlider:build_thumb(nSgmts, iLen, bDefWidth)
    local m_eThumb = self.eThumb

    local iWidth
    local iHeight
    iWidth, iHeight = m_eThumb:get_texture():getDimensions()

    if not bDefWidth then
        iWidth = math.floor(iLen / nSgmts)
    end

    self:_set_split(nSgmts)
    self:set_current(math.min(self:get_current(), nSgmts))

    local m_eThumb = self.eThumb
    m_eThumb:build(iWidth, iHeight)
end

function CWndSlider:update_box(iLen, bVert)
    self.iLength = iLen
    self:_set_orientation(bVert)
end

function CWndSlider:_update_slider(iLen, nSgmts, bDefWidth, bVert)
    self:build_thumb(nSgmts, iLen, bDefWidth)
    self:update_box(iLen, bVert)
end

function CWndSlider:load(sSliderState, iLen, nSgmts, bDefWidth, bVert)
    self:_load_thumb(sSliderState)
    self:_update_slider(iLen, nSgmts, bDefWidth, bVert)
end

function CWndSlider:update(dt)
    -- do nothing
end

function CWndSlider:draw(iPx, iPy)
    draw_slider(self, iPx, iPy)
end
