--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("ui.struct.canvas.resource.layer.table")
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

    self.pProp:update_resources(tiItems, tiMobs, iNpc, iFieldEnter)
    self.pCanvas:build(self.pProp)
end

function CWndResource:set_dimensions(iWidth, iHeight)
    self.pCanvas:reset()

    local eTexture = self.pProp:get_background()
    eTexture:build(iWidth, iHeight)

    self.pCanvas:build(self.pProp)
end

function CWndResource:_load_table()
    local pTextureDataBgrd = ctVwRscs:get_background_data()

    local pVwRscs = CRscTableElem:new()
    pVwRscs:load(0, 0, pTextureDataBgrd)

    self.pProp:set_table(pVwRscs)
end

function CWndResource:load()
    self:_load_table()
    self.pCanvas:load({CResourceNavText}) -- follows sequence: LLayer
end

function CWndResource:update(dt)
    self.pCanvas:update(dt)
end

function CWndResource:draw()
    self.pCanvas:draw()
end

function CWndResource:get_layer(iLayer)
    return self.pCanvas:get_layer(iLayer)
end
