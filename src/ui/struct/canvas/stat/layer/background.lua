--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("ui.struct.canvas.stat.stat")
require("ui.struct.window.summary")
require("ui.struct.window.frame.layer")
require("utils.struct.class")

CStatNavBackground = createClass({CWndLayer, {}})

function CStatNavBackground:build(pStatProp)
    self:reset()

    -- add layer elements

    local pBaseProp = CStatElem:new()
    pBaseProp:load(pStatProp:get_base_img())

    self:add_element(LChannel.STAT_BGRD, pBaseProp)
end
