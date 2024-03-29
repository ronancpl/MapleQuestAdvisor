--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("ui.constant.view.resource")
require("ui.run.draw.canvas.resource.resource")
require("ui.struct.component.canvas.resource.item.item")
require("ui.struct.component.element.plaintext")
require("utils.struct.class")

CRscElemItemLink = createClass({CRscElemItem, {
    eTxtFieldRef = CTextElem:new()
}})

function CRscElemItemLink:get_desc()
    return self.sDesc
end

function CRscElemItemLink:get_object_desc()
    return self.eTxtDesc
end

function CRscElemItemLink:get_object_field_link()
    return self.eTxtFieldRef
end

function CRscElemItemLink:_load_text(sDesc, iFieldRef, pConfVw, iPx, iPy)
    local pFont = ctVwRscs:get_font_info()

    local sFieldName = ctFieldsMeta:get_area_name(iFieldRef)

    local m_eTxtFieldRef = self.eTxtFieldRef
    m_eTxtFieldRef:load(sFieldName, pFont, pConfVw.W - (2 * pConfVw.FIL_X), iPx + pConfVw.FIL_X, iPy + pConfVw.FIL_Y)
end

function CRscElemItemLink:load(siType, iId, tpRscGrid, sDesc, iFieldRef, pConfVw, bMini)
    self:_load(siType, iId, tpRscGrid, sDesc, pConfVw.W, pConfVw.H, iFieldRef, bMini)
    self:_set_origin(-1, -1)

    self.pConfVw = pConfVw
end

function CRscElemItemLink:update(dt)
    -- do nothing
end

function CRscElemItemLink:update_position(iPx, iPy)
    self:_set_origin(iPx, iPy)

    local m_sDesc = self.sDesc
    local m_iFieldRef = self.iFieldRef
    local m_pConfVw = self.pConfVw
    self:_load_text(m_sDesc, m_iFieldRef, m_pConfVw, iPx, iPy)
end

function CRscElemItemLink:draw()
    draw_resource_link(self)
end
