--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("router.procedures.constant")
require("ui.struct.window.summary")
require("ui.struct.window.element.basic.selectbox")
require("ui.struct.window.frame.layer")
require("utils.struct.class")

CWmapNavBackground = createClass({CWndLayer, {}})

function CWmapNavBackground:build(pWmapProp)
    self:reset()

    -- add layer elements

    local pPropBaseImg = pWmapProp:get_base_img()
    self:add_element(LChannel.WMAP_BGRD, pPropBaseImg)
end
