--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("ui.struct.component.basic.base")
require("utils.struct.class")

CUserboxElem = createClass({
    eElemLt = CBasicElem:new(),
    iWidth = 0,
    iHeight = 0,
    iZ
})

function CUserboxElem:get_origin()
    return self.eElemLt:get_pos()
end

function CUserboxElem:get_z()
    return self.iZ
end

function CUserboxElem:get_dimensions()
    return self.iWidth, self.iHeight
end

function CUserboxElem:get_ltrb()
    local m_eElemLt = self.eElemLt
    local iLx, iTy = m_eElemLt:get_pos()
    local iW, iH = self:get_dimensions()

    return iLx, iTy, iLx + iW, iTy + iH
end


function CUserboxElem:get_center()
    local iLx, iTy, iRx, iBy = self:get_ltrb()
    return (iLx + iRx) / 2, (iTy + iBy) / 2
end

function CUserboxElem:set_position(iLx, iTy)
    self.eElemLt:load(iLx, iTy)
end

function CUserboxElem:set_dimensions(iW, iH)
    self.iWidth = iW
    self.iHeight = iH
end

function CUserboxElem:load(iLx, iTy, iW, iH, iZ)
    self:set_position(iLx, iTy)
    self:set_dimensions(iW, iH)

    self.iZ = iZ
end

function CUserboxElem:update(dt)
    -- do nothing
end

function CUserboxElem:draw()
    -- do nothing
end
