--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("router.constants.path")
require("utils.struct.class")

CCanvasResource = createClass({
    sDesc,
    iFieldRef,

    eTxtDesc,
    eTxtFieldRef
})

function CCanvasResource:load_text(sDesc, iFieldRef, pConfVw, iPx, iPy)
    local pFont = ctVwRscs:get_font_info()

    local eTxtDesc = CTextElem:new()
    eTxtDesc:load(sDesc, pFont, iLineWidth, iPx, iPy)
    self.eTxtDesc = eTxtDesc

    local sFieldName = ctFieldsMeta:get_area_name(iFieldRef)

    local eTxtFieldRef = CTextElem:new()
    eTxtFieldRef:load(sFieldName, pFont, iLineWidth, iPx, iPy)
    self.eTxtFieldRef = eTxtFieldRef
end

function CCanvasResource:load(sDesc, iFieldRef)
    self.sDesc = sDesc
    self.iFieldRef = iFieldRef

    self:load_text(sDesc, iFieldRef)
end

function CCanvasResource:get_desc()
    return self.sDesc
end

function CCanvasResource:get_field_link()
    return self.iFieldRef
end

function CCanvasResource:get_text_desc()
    return self.pTxtDesc
end

function CCanvasResource:get_text_field_link()
    return self.pTxtFieldRef
end
