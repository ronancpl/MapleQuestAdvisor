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

CWmapNodeRegion = createClass({
    pNodeBaseImg,
    sParentMap,
    rgpNodeLinks,
    rgpNodeMarkers
})

function CWmapNodeRegion:get_base_img()
    return self.pNodeBaseImg
end

function CWmapNodeRegion:set_base_img(pNodeBaseImg)
    self.pNodeBaseImg = pNodeBaseImg
end

function CWmapNodeRegion:get_parent_map()
    return self.sParentMap
end

function CWmapNodeRegion:set_parent_map(sRegionName)
    self.sParentMap = sRegionName
end

function CWmapNodeRegion:get_links()
    return self.rgpNodeLinks
end

function CWmapNodeRegion:set_links(rgpNodeLinks)
    self.rgpNodeLinks = rgpNodeLinks
end

function CWmapNodeRegion:get_nodes()
    return self.rgpNodeMarkers
end

function CWmapNodeRegion:set_nodes(rgpNodeMarkers)
    self.rgpNodeMarkers = rgpNodeMarkers
end
