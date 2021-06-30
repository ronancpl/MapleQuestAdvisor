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

CPoolCanvas = createClass({

    ctInactiveCanvases = SMapTimed:new(),
    tpCanvasEntries = {}

})

local function fetch_key_table_canvas(iWidth, iHeight)
    return bit.lshift(iWidth, 30) + iHeight
end

function CPoolCanvas:_fetch_canvas(iWidth, iHeight)
    local iKey = fetch_key_table_canvas(iWidth, iHeight)

    local m_tpCanvasEntries = self.tpCanvasEntries
    local rgpCnvs = create_inner_table_if_not_exists(m_tpCanvasEntries, iKey)

    local pCnv = table.remove(rgpCnvs)
    if pCnv ~= nil then
        self.ctInactiveCanvases:remove(pCnv)
    end

    return pCnv
end

function CPoolCanvas:_take_canvas(iWidth, iHeight)
    local pCnv = self:_fetch_canvas(iWidth, iHeight)
    if pCnv == nil then
        pCnv = love.graphics.newCanvas(iWidth, iHeight)
        self.ctInactiveCanvases:insert(pCnv, 1, RTimer.TM_UI_POOL)
    end

    return pCnv
end

function CPoolCanvas:take_canvas(iWidth, iHeight)
    local pCnv = self:_take_canvas(iWidth, iHeight)
    return pCnv
end

function CPoolCanvas:put_canvas(pCnv)
    local iWidth, iHeight = pCnv:getDimensions()
    local iKey = fetch_key_table_canvas(iWidth, iHeight)

    local rgpCnvs = create_inner_table_if_not_exists(self.tpCanvasEntries, iKey)

    table.insert(rgpCnvs, pCnv)
    self.ctInactiveCanvases:insert(pCnv, 1, RTimer.TM_UI_POOL)
end
