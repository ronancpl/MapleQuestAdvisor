--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("utils.procedure.unpack")
require("utils.struct.class")

CWmapNodeRegion = createClass({
    sName,
    pImgBase,
    sParentMap,
    tpNodeLinks,
    tpNodeMarkers,
    tpAreaNodes
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
    return self.tpNodeLinks
end

function CWmapNodeRegion:set_links(tpNodeLinks)
    self.tpNodeLinks = tpNodeLinks
end

function CWmapNodeRegion:get_nodes()
    return self.tpNodeMarkers
end

function CWmapNodeRegion:set_nodes(tpNodeMarkers)
    self.tpNodeMarkers = tpNodeMarkers
end

function CWmapNodeRegion:make_remissive_index_area_region()
    self.tpAreaNodes = {}
    local m_tpAreaNodes = self.tpAreaNodes

    for iNodeid, pMarker in pairs(self:get_nodes()) do
        local rgiMapids = pMarker:get_mapno():list()
        for _, iMapid in ipairs(rgiMapids) do
            m_tpAreaNodes[iMapid] = iNodeid
        end
    end
end

function CWmapNodeRegion:get_node_by_mapid(iMapid)
    local m_tpAreaNodes = self.tpAreaNodes
    return m_tpAreaNodes[iMapid]
end

function CWmapNodeRegion:get_areas()
    local m_tpAreaNodes = self.tpAreaNodes
    return keys(m_tpAreaNodes)
end
