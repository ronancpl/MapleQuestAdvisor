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

    pPool = CPool:new()

})

local function get_key_table_font(sFont, iHeight)
    return sFont .. tostring(iHeight)
end

local function fn_create_item(sFont, iHeight)
    return love.graphics.newFont(sFont, iHeight)
end

function CPoolFont:init()
    self.pPool:load(get_key_table_font, fn_create_item)
end

function CPoolFont:take_font(sFont, iHeight)
    local m_pPool = self.pPool

    local pFont = m_pPool:take_object({sFont, iHeight})
    log_st(LPath.INTERFACE, "_vwf.txt", " load '" .. tostring(pFont) .. " | " .. tostring(sFont) .. " " .. tostring(iHeight) .. "'")
    return pFont
end

function CPoolFont:put_font(pFont, sFont, iHeight)
    log_st(LPath.INTERFACE, "_vwf.txt", " free '" .. tostring(pFont) .. " | " .. tostring(sFont) .. " " .. tostring(iHeight) .. "'")
    local m_pPool = self.pPool
    m_pPool:put_object(pFont, {sFont, iHeight})
end
