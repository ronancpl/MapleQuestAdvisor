--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("ui.struct.window.layer")
require("utils.struct.class")

CWmapNavFragment = createClass({CWndLayer, {}})

function CWmapNavFragment:build(pWmapProp)
    self:reset()

    -- add layer elements

    local sWmapRegion = pWmapProp:get_parent_map()

    local rgpFieldMarkers = pWmapProp:get_map_fields()

    local pFieldMarker = rgpFieldMarkers[1]

    local pElemTbox = pFieldMarker:get_textbox()
    self:add_element(1, pElemTbox)

    local iX, iY = love.mouse.getPosition()

    local pFont = love.graphics.newFont(RInterface.LOVE_FONT_DIR_PATH .. "arial.ttf", 16)

    -- draw mouse position
    love.graphics.printf("x:" .. tostring(iX) .. " y:" .. tostring(iY), pFont, 700, 50, 100, "justify")

end
