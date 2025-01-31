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
    return self.trgiFieldsRef
end

function CRscElemItem:_load_tooltip(sDesc)
    local m_pTooltip = self.pTooltip
    m_pTooltip:load(sDesc)
end

function CRscElemItem:_load(siType, iId, tpRscGrid, sDesc, iPictW, iPictH, trgiFieldsRef, bMini)
    self.iId = iId
    self.siType = siType
    self.bMini = bMini
    self.pConfVw = tpRscGrid[siType]
    self.trgiFieldsRef = trgiFieldsRef
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
    pFrameBasic:get_cursor():update_state(RWndPath.MOUSE.BT_CLICKABLE)
    self:show_tooltip()
end

function CRscElemItem:onmousehoverout()
    self:hide_tooltip()
    pFrameBasic:get_cursor():update_state(-RWndPath.MOUSE.BT_CLICKABLE)
end

function CRscElemItem:_act_inspect_resource(sWmapName)
    pUiWmap:update_region(sWmapName, pUiRscs, self)
end

local function get_area_regionid(pPlayer)
    return ctFieldsLandscape:get_region_by_mapid(pPlayer:get_mapid())
end

local function get_worldmap_regionids(pUiWmap)
    local tpRegionids = {}

    for _, iMapid in ipairs(pUiWmap:get_properties():get_fields()) do
        local iWmapRegionid = ctFieldsLandscape:get_region_by_mapid(iMapid)
        if iWmapRegionid ~= nil then
            tpRegionids[iWmapRegionid] = 1
        end
    end

    return keys(tpRegionids)
end

function CRscElemItem:_access_field_ref()
    local iFieldRef = self:get_field_link()
    if iFieldRef ~= nil and type(iFieldRef) == "table" then
        local trgiFields = iFieldRef

        local rgiRegionids = get_worldmap_regionids(pUiWmap)
        for _, iRegionid in ipairs(rgiRegionids) do
            local rgiFields = trgiFields[iRegionid]
            if rgiFields ~= nil and #rgiFields > 0 then
                return rgiFields[1]
            end
        end

        local pPlayer = pUiWmap:get_properties():get_player()
        local iRegionid = get_area_regionid(pPlayer)
        local rgiFields = trgiFields[iRegionid]
        if rgiFields ~= nil and #rgiFields > 0 then
            return rgiFields[1]
        end

        return nil
    end

    return iFieldRef
end

function CRscElemItem:onmousereleased(x, y, button)
    if button == 1 then
        local iFieldRef = self:_access_field_ref()
        if iFieldRef ~= nil then
            local sWmapName = ctFieldsWmap:get_worldmap_name_by_area(iFieldRef)

            self:_act_inspect_resource(sWmapName)
            pFrameBasic:get_cursor():update_state(-RWndPath.MOUSE.BT_CLICKABLE)
        end
    end
end
