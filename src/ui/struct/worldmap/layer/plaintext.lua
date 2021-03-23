--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("ui.constant.config")
require("ui.constant.path")
require("ui.struct.worldmap.element.plaintext")
require("ui.struct.window.frame.layer")
require("utils.struct.class")

CWmapNavInfo = createClass({CWndLayer, {
    pFont = love.graphics.newFont(RWndPath.LOVE_FONT_DIR_PATH .. "arial.ttf", 12),
    iCurX = 0,
    iCurY = 0,
    iMaxX = iSegX,
    iMaxY = iSegY,
    rgpVert = {}
}})

function CWmapNavInfo:_find_screen_position()
    local iSegX, iSegY = unpack(RWndConfig.PTXT_SGMNT_SIZE)
    local iBrdX, iBrdY = unpack(RWndConfig.PTXT_BOARD)

    local m_iCurX = self.iCurX
    local iNextX = m_iCurX + iSegX
    if iNextX < iBrdX then
        iPosX = m_iCurX
        iPosY = iBrdY

        self.iCurX = iNextX
        return {iPosX, iPosY}
    end

    local m_iCurY = self.iCurY
    local iNextY = m_iCurY + iSegY
    if iNextY > iBrdY + iSegY then
        iPosX = iBrdX
        iPosY = iCurY

        self.iCurY = iNextY
        return {iPosX, iPosY}
    end

    return nil
end

function CWmapNavInfo:add_text_element(sText)
    local pPos = self:_find_screen_position()
    if pPos ~= nil then
        local iSegX, _ = unpack(RWndConfig.PTXT_SGMNT_SIZE)
        local pPropText = CWmapElemPlaintext:new()

        local iPx, iPy = unpack(pPos)
        pPropText:load(sText, self.pFont, iSegX, iPx, iPy)
        pPropText:visible()

        self:add_element(LChannel.PLAINTXT, pPropText)
    end
end

function CWmapNavInfo:build(pWmapProp)
    self:reset()

    -- do nothing, elements added by interaction

end
