--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("utils.struct.class")

CWmapLink = createClass({
    sTooltip,
    pNodeLink
})

function CWmapLink:get_tool_tip()
    return self.sTooltip
end

function CWmapLink:set_tool_tip(sTooltip)
    self.sTooltip = sTooltip
end

function CWmapLink:get_link()
    return self.pNodeLink
end

function CWmapLink:set_link(pNodeLink)
    self.pNodeLink = pNodeLink
end
