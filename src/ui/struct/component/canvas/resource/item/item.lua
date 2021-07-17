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
require("solver.graph.resource.label")
require("ui.constant.path")
require("ui.struct.component.basic.base")
require("ui.struct.component.canvas.resource.item.tooltip")
require("ui.struct.window.summary")
require("utils.struct.class")

CRscElemItem = createClass({
    eBox = CUserboxElem:new(),
    iId,
    siType,
    bMini,
    iFieldRef,
    pTooltip = CCanvasTooltip:new()
})

function CRscElemItem:get_origin()
    return self.eBox:get_origin()
end

function CRscElemItem:_set_origin(iRx, iRy)
    self.eBox:set_position(iRx, iRy)
end

function CRscElemItem:get_object()
    return self.eBox
end

function CRscElemItem:get_type()
    return self.siType
end

function CRscElemItem:get_conf()
    return self.pConfVw
end

function CRscElemItem:get_id()
    return self.iId
end

function CRscElemItem:get_resource_id()
    return get_tab_resource_id(self.siType, self.iId)
end

function CRscElemItem:get_field_link()
    return self.iFieldRef
end

function CRscElemItem:_load_tooltip(sDesc)
    local m_pTooltip = self.pTooltip
    m_pTooltip:load(sDesc)
end

function CRscElemItem:_load(siType, iId, tpRscGrid, sDesc, iPictW, iPictH, iFieldRef, bMini)
    self.iId = iId
    self.siType = siType
    self.bMini = bMini
    self.pConfVw = tpRscGrid[siType]
    self.iFieldRef = iFieldRef
    self.eBox:load(-1, -1, iPictW, iPictH)

    self:_load_tooltip(sDesc)
end

function CRscElemItem:update(dt)
    -- do nothing
end

function CRscElemItem:reset()
    -- do nothing
end

function CRscElemItem:free()
    self.pTooltip:free()
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
    pFrameBasic:get_cursor():load_mouse(RWndPath.MOUSE.BT_CLICKABLE)
    self:show_tooltip()
end

function CRscElemItem:onmousehoverout()
    self:hide_tooltip()
    pFrameBasic:get_cursor():load_mouse(-RWndPath.MOUSE.BT_CLICKABLE)
end

function CRscElemItem:_act_inspect_resource(sWmapName)
    pUiWmap:update_region(sWmapName, pUiRscs, self)
end

function CRscElemItem:onmousereleased(x, y, button)
    local m_iFieldRef = self.iFieldRef

    if m_iFieldRef ~= nil then
        local sWmapName = ctFieldsWmap:get_worldmap_name_by_area(m_iFieldRef)

        self:_act_inspect_resource(sWmapName)
        pFrameBasic:get_cursor():load_mouse(-RWndPath.MOUSE.BT_CLICKABLE)
    end
end
