--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("composer.field.node.media.image")
require("ui.run.build.canvas.worldmap.element.map_list")
require("ui.run.build.interface.storage.split")
require("ui.struct.canvas.worldmap.basic.textbox")
require("ui.struct.canvas.worldmap.element.mark_ptr")
require("ui.struct.component.basic.base")
require("ui.struct.component.element.dynamic")
require("ui.struct.window.summary")
require("utils.struct.class")

CWmapElemMark = createClass({
    eDynam = CDynamicElem:new(),
    eElem = CBasicElem:new(),
    siType,
    rgiFields,
    pPath,
    pTextbox,
    pTooltip
})

function CWmapElemMark:get_object()
    return self.eDynam
end

function CWmapElemMark:get_mapno()
    return self.rgiFields
end

function CWmapElemMark:set_mapno(rgiFields)
    self.rgiFields = rgiFields
end

function CWmapElemMark:contains(iField)
    for _, iMapid in ipairs(self.rgiFields) do
        if iMapid == iField then
            return true
        end
    end

    return false
end

function CWmapElemMark:get_path()
    return self.pPath
end

function CWmapElemMark:set_path(pPath)
    self.pPath = pPath
end

function CWmapElemMark:get_textbox()
    return self.pTextbox
end

function CWmapElemMark:set_textbox(pTextbox)
    self.pTextbox = pTextbox
end

function CWmapElemMark:get_type()
    return self.siType
end

function CWmapElemMark:_set_type(siType)
    self.siType = siType
end

function CWmapElemMark:update_type(siType, pWmapProp, pDirHelperQuads)
    self:_set_type(siType)
    load_quad_map_marker(self, pWmapProp, pDirHelperQuads)
end

function CWmapElemMark:get_tooltip()
    return self.sTooltip
end

local function load_map_marker_quads(pDirHelperQuads, sTooltip)
    local rgpQuads = find_animation_on_storage(pDirHelperQuads, sTooltip)
    return rgpQuads
end

function CWmapElemMark:remove_tooltip_element()
    local m_pTooltip = self.pTooltip
    if m_pTooltip ~= nil then
        local pLyr = pUiWmap:get_layer(LLayer.NAV_WMAP_MISC)
        pLyr:remove_element(LChannel.WMAP_MARK_TTIP, m_pTooltip)
    end
end

function CWmapElemMark:add_tooltip_element(pTooltip)
    if pTooltip ~= nil then
        local pLyr = pUiWmap:get_layer(LLayer.NAV_WMAP_MISC)
        pLyr:add_element(LChannel.WMAP_MARK_TTIP, pTooltip)
    end
end

function CWmapElemMark:set_tooltip(sTooltip, pDirHelperQuads, pWmapProp)
    local pTooltip
    if sTooltip ~= nil then
        pTooltip = CWmapElemPointer:new()

        local rgpQuads = load_map_marker_quads(pDirHelperQuads, sTooltip)

        local iPx, iPy = self:get_object():get_center()

        local iCx
        local iCy
        iCx, iCy = pWmapProp:get_origin()

        pTooltip:load(iPx - iCx, iPy - 10 - iCy, pWmapProp, rgpQuads)
    else
        pTooltip = nil
    end

    self:remove_tooltip_element()
    self:add_tooltip_element(pTooltip)
    self.pTooltip = pTooltip
end

function CWmapElemMark:set_static(bStatus)
    self.eDynam:set_static(bStatus)
end

function CWmapElemMark:active()
    self:set_static(false)
end

function CWmapElemMark:static()
    self:set_static(true)
end

function CWmapElemMark:reset()
    self:static()

    local m_pTextbox = self:get_textbox()
    if m_pTextbox ~= nil then
        m_pTextbox:hidden()     -- unrenderize after canvas reset
    end
end

function CWmapElemMark:_load_quad(rX, rY, rgpQuads, pWmapProp)
    local m_eDynam = self.eDynam

    m_eDynam:load(rX, rY, rgpQuads)
    m_eDynam:instantiate(pWmapProp, true)
    m_eDynam:after_load()
    self:reset()
end

function CWmapElemMark:reload_quad(rgpQuads, pWmapProp)
    local rX, rY = self.eElem:get_pos()
    self:_load_quad(rX, rY, rgpQuads, pWmapProp)
end

function load_quad_empty()
    local pImgData = load_image_empty()

    local pQuad = CBasicQuad:new()
    pQuad:load(pImgData, 0, 0, 1, RWndConfig.QUAD_DELAY_DEF)

    return pQuad
end

function CWmapElemMark:load(rX, rY, siType, pWmapProp)
    local rgpQuads = {load_quad_empty()}

    self:_set_type(siType)

    self.eElem:load(rX, rY)
    self:_load_quad(rX, rY, rgpQuads, pWmapProp)
end

function CWmapElemMark:update(dt)
    self.eDynam:update(dt)
end

function CWmapElemMark:draw()
    self.eDynam:draw()
end

function CWmapElemMark:onmousehoverin()
    local m_pTextbox = self.pTextbox
    if m_pTextbox ~= nil then
        m_pTextbox:visible()

        local pLyr = pUiWmap:get_layer(LLayer.NAV_WMAP_MISC)
        pLyr:add_element(LChannel.WMAP_MARK_TBOX, m_pTextbox)
    end

    local m_pPath = self:get_path()
    if m_pPath ~= nil then
        local pLyr = pUiWmap:get_layer(LLayer.NAV_WMAP_MISC)
        pLyr:add_element(LChannel.WMAP_MARK_PATH, m_pPath)
    end
end

function CWmapElemMark:onmousehoverout()
    local m_pTextbox = self.pTextbox
    if m_pTextbox ~= nil then
        m_pTextbox:hidden()

        local pLyr = pUiWmap:get_layer(LLayer.NAV_WMAP_MISC)
        pLyr:remove_element(LChannel.WMAP_MARK_TBOX, m_pTextbox)
    end

    local m_pPath = self:get_path()
    if m_pPath ~= nil then
        local pLyr = pUiWmap:get_layer(LLayer.NAV_WMAP_MISC)
        pLyr:remove_element(LChannel.WMAP_MARK_PATH, m_pPath)
    end
end
