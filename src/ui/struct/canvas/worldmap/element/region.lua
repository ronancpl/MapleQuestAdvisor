--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("ui.struct.component.element.static")
require("ui.struct.window.summary")
require("utils.struct.class")

CWmapElemRegionLink = createClass({
    eConst = CStaticElem:new(),
    sLinkMap,
    sTooltip,

    bVisible = false
})

function CWmapElemRegionLink:get_object()
    return self.eConst
end

function CWmapElemRegionLink:load(pWmapProp, pImg, iOx, iOy, iZ, rX, rY)
    self.eConst:load(pImg, iOx, iOy, iZ, rX, rY)
    self.eConst:instantiate(pWmapProp, true)
end

function CWmapElemRegionLink:reset()
    self.bVisible = false
end

function CWmapElemRegionLink:get_z()
    return self.eConst:get_z()
end

function CWmapElemRegionLink:get_link_map()
    return self.sLinkMap
end

function CWmapElemRegionLink:set_link_map(sLinkMap)
    self.sLinkMap = sLinkMap
end

function CWmapElemRegionLink:set_tooltip(sTooltip)
    self.sTooltip = sTooltip
end

function CWmapElemRegionLink:update(dt)
    self.eConst:update(dt)
end

function CWmapElemRegionLink:draw()
    if self.bVisible then
        self.eConst:draw()
    end
end

function CWmapElemRegionLink:visible()
    self.bVisible = true
end

function CWmapElemRegionLink:hidden()
    self.bVisible = false
end

function CWmapElemRegionLink:onmousehoverin()
    local pLyr = pUiWmap:get_layer(LLayer.NAV_WMAP_MAPLINK)
    pLyr:add_link_visible(self)
end

function CWmapElemRegionLink:onmousehoverout()
    local pLyr = pUiWmap:get_layer(LLayer.NAV_WMAP_MAPLINK)
    pLyr:remove_link_visible(self)
end

function CWmapElemRegionLink:_access_inner_map()
    local sWmapName = self:get_link_map()
    if sWmapName ~= "" then
        pUiWmap:update_region(sWmapName, pUiRscs)
    end
end

function CWmapElemRegionLink:onmousereleased(rx, ry, button)
    if button == 1 then
        local pLyr = pUiWmap:get_layer(LLayer.NAV_WMAP_MAPLINK)
        if pLyr:is_link_visible(self) then
            self:_access_inner_map()
        end
    end
end
