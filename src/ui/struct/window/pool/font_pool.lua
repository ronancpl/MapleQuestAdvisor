--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("utils.struct.class")
require("utils.struct.pool")

CPoolFont = createClass({

    pPoolFont = CPool:new(),
    pPoolText = CPool:new()

})

local function get_key_table_font(sFont, iHeight)
    return sFont .. tostring(iHeight)
end

local function fn_create_item(sFont, iHeight)
    return love.graphics.newFont(sFont, iHeight)
end

local function get_key_table_text(pFont)
    return tostring(pFont)
end

local function fn_create_item_text(pFont)
    return love.graphics.newText(pFont)
end

function CPoolFont:init()
    self.pPoolFont:load(get_key_table_font, fn_create_item)
    self.pPoolText:load(get_key_table_text, fn_create_item_text)
end

function CPoolFont:take_font(sFont, iHeight)
    local m_pPool = self.pPoolFont

    local pFont = m_pPool:take_object({sFont, iHeight})
    return pFont
end

function CPoolFont:put_font(pFont, sFont, iHeight)
    local m_pPool = self.pPoolFont
    m_pPool:put_object(pFont, {sFont, iHeight})
end

function CPoolFont:take_text(pFont)
    local m_pPoolText = self.pPoolText

    local pText = m_pPoolText:take_object({pFont})
    return pText
end

function CPoolFont:put_text(pFont, pText)
    local m_pPoolText = self.pPoolText
    m_pPoolText:put_object(pFont, {pText})
end
