--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("ui.struct.component.element.dynamic")
require("ui.struct.window.summary")
require("ui.struct.worldmap.basic.textbox")
require("utils.struct.class")

CWmapElemMark = createClass({
    eDynam = CDynamicElem:new(),
    rgiFields,
    pPath,
    pTextbox
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

function CWmapElemMark:load(rX, rY, rgpQuads, pWmapProp)
    self.eDynam:load(rX, rY, rgpQuads)
    self.eDynam:instantiate(pWmapProp, true)
    self.eDynam:after_load()
end

function CWmapElemMark:reset()
    local m_pTextbox = self:get_textbox()
    if m_pTextbox ~= nil then
        m_pTextbox:hidden()     -- unrenderize after canvas reset
    end
end

function CWmapElemMark:update(dt)
    self.eDynam:update(dt)

    local m_pTextbox = self:get_textbox()
    if m_pTextbox ~= nil then
        m_pTextbox:update(dt)
    end
end

function CWmapElemMark:draw()
    self.eDynam:draw()
end

function CWmapElemMark:onmousehoverin()
    local m_pTextbox = self.pTextbox
    if m_pTextbox ~= nil then
        m_pTextbox:visible()

        local pLyr = pUiWmap:get_layer(LLayer.NAV_WMAP_MISC)
        pLyr:add_element(LChannel.MARK_TBOX, m_pTextbox)
    end

    local m_pPath = self:get_path()
    if m_pPath ~= nil then
        local pLyr = pUiWmap:get_layer(LLayer.NAV_WMAP_MISC)
        pLyr:add_element(LChannel.WMAP_MARK_PATH, m_pPath)
    end
end

function CWmapElemMark:onmousehoverout()
    local m_pTextbox = self.pTextbox
    if m_pTextbox then
        m_pTextbox:hidden()

        local pLyr = pUiWmap:get_layer(LLayer.NAV_WMAP_MISC)
        pLyr:add_element(LChannel.MARK_TBOX, m_pTextbox)
    end

    local m_pPath = self:get_path()
    if m_pPath ~= nil then
        local pLyr = pUiWmap:get_layer(LLayer.NAV_WMAP_MISC)
        pLyr:remove_element(LChannel.WMAP_MARK_PATH, m_pPath)
    end
end
