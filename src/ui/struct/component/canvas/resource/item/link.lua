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

CCanvasRscLink = createClass({CCanvasResource, {
    sDesc,
    iFieldRef,

    eTxtDesc = CTextElem:new(),
    eTxtFieldRef = CTextElem:new()
}})

function CCanvasRscLink:get_desc()
    return self.sDesc
end

function CCanvasRscLink:get_field_link()
    return self.iFieldRef
end

function CCanvasRscLink:get_object_desc()
    return self.eTxtDesc
end

function CCanvasRscLink:get_object_field_link()
    return self.eTxtFieldRef
end

function CCanvasResource:_load_text(sDesc, iFieldRef, pConfVw, iPx, iPy)
    local pFont = ctVwRscs:get_font_info()

    local m_eTxtDesc = self.eTxtDesc
    m_eTxtDesc:load(sDesc, pFont, 10, iPx + pConfVw.ST_X + pConfVw.FIL_X, iPy + pConfVw.ST_Y + pConfVw.FIL_Y)

    local sFieldName = ctFieldsMeta:get_area_name(iFieldRef)

    local m_eTxtFieldRef = self.eTxtFieldRef
    m_eTxtFieldRef:load(sFieldName, pFont, 10, iPx + pConfVw.FIELD_X + pConfVw.FIL_X, iPy + pConfVw.ST_Y + pConfVw.FIL_Y)
end

function CCanvasRscLink:load(sDesc, iFieldRef, pConfVw)
    self.sDesc = sDesc
    self.iFieldRef = iFieldRef
    self.pConfVw = pConfVw

    self:_load(sDesc)
    self:_update_position(-1, -1)
end

function CCanvasRscLink:update(iPx, iPy)
    self:_update_position(iPx, iPy)

    local m_sDesc = self.sDesc
    local m_iFieldRef = self.iFieldRef
    local m_pConfVw = self.pConfVw
    self:_load_text(m_sDesc, m_iFieldRef, m_pConfVw, iPx, iPy)
end

function CCanvasRscLink:draw()
    draw_resource_link(self)
end
