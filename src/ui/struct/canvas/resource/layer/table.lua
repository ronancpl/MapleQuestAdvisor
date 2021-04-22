--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("ui.constant.path")
require("ui.struct.canvas.stat.element.plaintext")
require("ui.struct.window.summary")
require("ui.struct.window.frame.layer")
require("utils.struct.class")

CResourceNavTable = createClass({CWndLayer, {
    pFont = love.graphics.newFont(RWndPath.LOVE_FONT_DIR_PATH .. "arial.ttf", 12)
}})

function CResourceNavTable:_build_element(pElemRsc)
    self:add_element(LChannel.RSC_INFO, pElemRsc)
end

function CResourceNavTable:_build_element(sText, iPx, iPy)
    local pPropText = CRscElemPlaintext:new()

    pPropText:load(sText or "-", self.pFont, 100, iPx, iPy)
    pPropText:visible()

    self:add_element(LChannel.WMAP_PLAINTXT, pPropText)
end

function CResourceNavTable:build(pRscProp)
    self:reset()

    -- add layer elements

    local pElemRsc = pRscProp:get_table()
    self:_build_element(pElemRsc)
end
