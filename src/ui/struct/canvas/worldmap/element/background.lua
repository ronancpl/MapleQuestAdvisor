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
require("utils.struct.class")

CWmapElemBackground = createClass({
    eConst = CStaticElem:new()
})

function CWmapElemBackground:get_object()
    return self.eConst
end

function CWmapElemBackground:get_center()
    return self.eConst:get_origin()
end

function CWmapElemBackground:load(pWmapProp, pImg, iOx, iOy, iZ, rX, rY)
    self.eConst:load(pImg, iOx, iOy, iZ, rX, rY)
    self.eConst:instantiate(pWmapProp, true)
end

function CWmapElemBackground:reset()
    -- do nothing
end

function CWmapElemBackground:update(dt)
    self.eConst:update(dt)
end

function CWmapElemBackground:draw()
    self.eConst:draw()
end

local function access_parent_map()
    local sParentWmapName = pUiWmap:get_properties():get_parent_map()
    if sParentWmapName ~= "" then
        pUiWmap:update_region(sParentWmapName)
    end
end

function CWmapElemBackground:onmousereleased(rx, ry, button)
    if button == 2 then
        access_parent_map()
    end
end
