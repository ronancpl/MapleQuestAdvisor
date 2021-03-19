--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("ui.struct.window.summary")
require("ui.struct.window.frame.layer")
require("ui.struct.worldmap.element.mark")
require("utils.struct.class")

CWmapNavMapList = createClass({CWndLayer, {}})

function CWmapNavMapList:_build_element(pPropMarker)
    self:add_element(LChannel.MARK, pPropMarker)
end

function CWmapNavMapList:build(pWmapProp)
    self:reset()

    -- add layer elements

    local rgpPropMarkers = pWmapProp:get_map_fields()
    for _, pPropMarker in ipairs(rgpPropMarkers) do
        self:_build_element(pPropMarker)
    end

end
