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
require("ui.struct.component.basic.base")
require("ui.struct.component.canvas.resource.item.tooltip")
require("ui.run.draw.canvas.resource.resource")
require("utils.struct.class")

CRscElemItem = createClass({
    eBox = CUserboxElem:new(),
    iId,
    siType,
    pTooltip = CCanvasTooltip:new()
})

function CRscElemItem:_update_position(iRx, iRy)
    self.eBox:set_position(iRx, iRy)
end

function CRscElemItem:get_position()
    return self.eBox:get_origin()
end

function CRscElemItem:get_object()
    return self.eBox
end

function CRscElemItem:get_type()
    return self.siType
end

function CRscElemItem:get_id()
    return self.iId
end

function CRscElemItem:_load_tooltip(sDesc)
    local m_pTooltip = self.pTooltip
    m_pTooltip:load(sDesc)
end

function CRscElemItem:_load(siType, iId, sDesc, iPictW, iPictH)
    self.iId = iId
    self.siType = siType
    self.eBox:load(-1, -1, iPictW, iPictH)

    self:_load_tooltip(sDesc)
end

function CRscElemItem:update(dt)
    -- do nothing
end


function CRscElemItem:reset()
    -- do nothing
end

function CRscElemItem:draw_tooltip()
    draw_resource_tooltip(self)
end

function CRscElemItem:show_tooltip()
    local m_pTooltip = self.pTooltip
    local pTextbox = m_pTooltip:get_textbox()

    if pTextbox ~= nil and not pTextbox:is_visible() then
        pTextbox:visible()

        local pLyr = pUiRscs:get_layer(LLayer.NAV_RSC_TABLE)
        pLyr:add_element(LChannel.RSC_DESC, pTextbox)
    end
end

function CRscElemItem:hide_tooltip()
    local m_pTooltip = self.pTooltip
    local pTextbox = m_pTooltip:get_textbox()

    if pTextbox ~= nil and pTextbox:is_visible() then
        pTextbox:hidden()

        local pLyr = pUiRscs:get_layer(LLayer.NAV_RSC_TABLE)
        pLyr:remove_element(LChannel.RSC_DESC, pTextbox)
    end
end

function CRscElemItem:onmousehoverin()
    self:show_tooltip()
end

function CRscElemItem:onmousehoverout()
    self:hide_tooltip()
end
