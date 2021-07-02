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

local bit = require("bit")

CPoolCanvas = createClass({

    pPool = CPool:new()

})

local function get_key_table_canvas(iWidth, iHeight)
    return bit.lshift(iWidth, 30) + iHeight
end

local function fn_create_item(iWidth, iHeight)
    return love.graphics.newCanvas(iWidth, iHeight)
end

function CPoolCanvas:init()
    self.pPool:load(get_key_table_canvas, fn_create_item)
end

function CPoolCanvas:take_canvas(iWidth, iHeight)
    local m_pPool = self.pPool
    return m_pPool:take_object({iWidth, iHeight})
end

function CPoolCanvas:put_canvas(pCnv)
    local m_pPool = self.pPool

    local iWidth, iHeight = pCnv:getDimensions()
    m_pPool:put_object(pCnv, {iWidth, iHeight})
end
