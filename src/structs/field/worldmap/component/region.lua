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
    sName,
    pImgBase,
    sParentMap,
    rgpNodeLinks,
    rgpNodeMarkers
})

function CWmapNodeRegion:get_name()
    return self.sName
end

function CWmapNodeRegion:set_name(sName)
    self.sName = sName
end

function CWmapNodeRegion:get_base_img()
    return self.pImgBase
end

function CWmapNodeRegion:set_base_img(pImgBase)
    self.pImgBase = pImgBase
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
