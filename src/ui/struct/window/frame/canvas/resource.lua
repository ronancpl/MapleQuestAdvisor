--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("ui.struct.canvas.resource.properties")
require("ui.struct.canvas.resource.layer.table")
require("ui.struct.component.canvas.resource.table")
require("ui.struct.component.element.texture")
require("utils.struct.class")

CWndResource = createClass({
    pCanvas = CWndCanvas:new(),
    pProp = CRscProperties:new()
})

function CWndResource:get_properties()
    return self.pProp
end

function CWndResource:update_resources(tiItems, tiMobs, iNpc, iFieldEnter)
    self.pCanvas:reset()

    local m_pProp = self.pProp
    m_pProp:update_resources(tiItems, tiMobs, iNpc, iFieldEnter)

    local pVwRscs = m_pProp:get_table()
    local fn_update_items = pVwRscs:get_fn_update_items()
    fn_update_items(pVwRscs, m_pProp)

    self.pCanvas:build(m_pProp)
end

function CWndResource:set_dimensions(iWidth, iHeight)
    self.pCanvas:reset()

    local m_pProp = self.pProp
    local eTexture = m_pProp:get_table():get_background()

    a = 7
    eTexture:build(iWidth, iHeight)
    a = nil

    self.pCanvas:build(m_pProp)
end

function CWndResource:_load_table()
    local pTextureDataBgrd = ctVwRscs:get_background_data()

    local pVwRscs = CRscTableElem:new()
    pVwRscs:load(0, 0, pTextureDataBgrd)

    pVwRscs:set_tab_selected(1)

    self.pProp:set_table(pVwRscs)
end

function CWndResource:load()
    self:_load_table()
    self.pCanvas:load({CResourceNavTable}) -- follows sequence: LLayer
end

function CWndResource:update(dt)
    self.pCanvas:update(dt)
end

function CWndResource:draw()
    self.pCanvas:draw()
end

function CWndResource:onmousemoved(x, y, dx, dy, istouch)
    self.pCanvas:onmousemoved(x, y, dx, dy, istouch)
end

function CWndResource:onmousepressed(x, y, button)
    self.pCanvas:onmousepressed(x, y, button)
end

function CWndResource:onmousereleased(x, y, button)
    self.pCanvas:onmousereleased(x, y, button)
end

function CWndResource:onwheelmoved(dx, dy)
    self.pCanvas:onwheelmoved(dx, dy)
end

function CWndResource:get_layer(iLayer)
    return self.pCanvas:get_layer(iLayer)
end
