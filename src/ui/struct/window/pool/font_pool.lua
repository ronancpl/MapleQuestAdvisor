--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("router.constants.timer")
require("utils.procedure.unpack")
require("utils.struct.class")
require("utils.struct.maptimed")

CPoolFont = createClass({

    ctInactiveFonts = SMapTimed:new(),
    tpFontEntries = {}

})

local function fetch_key_table_font(sFont, iHeight)
    return sFont .. tostring(iHeight)
end

function CPoolFont:_fetch_font(sFont, iHeight)
    local sFont = fetch_key_table_font(sFont, iHeight)

    local m_tpFontEntries = self.tpFontEntries
    local rgpFonts = create_inner_table_if_not_exists(m_tpFontEntries, sFont)

    local pFont = table.remove(rgpFonts)
    if pFont ~= nil then
        self.ctInactiveFonts:remove(pFont)
    end

    return pFont
end

function CPoolFont:_take_font(sFont, iHeight)
    local pFont = self:_fetch_font(sFont, iHeight)
    if pFont == nil then
        pFont = love.graphics.newFont(sFont, iHeight)
        self.ctInactiveFonts:insert(pFont, 1, RTimer.TM_UI_POOL)
    end

    return pFont
end

function CPoolFont:take_font(sFont, iHeight)
    local pFont = self:_take_font(sFont, iHeight)
    return pFont
end
