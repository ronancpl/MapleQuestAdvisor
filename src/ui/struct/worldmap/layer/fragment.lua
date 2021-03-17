--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("ui.struct.window.frame.layer")
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

    -- add informative elements

    local iRx, iRy = love.mouse.getPosition()
    local pFont = love.graphics.newFont(RWndPath.LOVE_FONT_DIR_PATH .. "arial.ttf", 16)

    local sText = "(" .. (iRx) .. ", " .. (iRy) .. ")"
    love.graphics.printf(sText, 650, 10, 1000)

end
