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

CWmapNavTrack = createClass({CWndLayer, {
    pVwTrace
}})

function CWmapNavTrack:get_trace()
    return self.pVwTrace
end

function CWmapNavTrack:set_trace(pVwTrace)
    self.pVwTrace = pVwTrace
end

function CWmapNavTrack:build(pWmapProp)
    self:reset()

    -- do nothing, elements added by interaction

end
