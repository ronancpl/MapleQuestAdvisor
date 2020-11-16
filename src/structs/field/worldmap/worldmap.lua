--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("utils.struct.class")

CWorldmapRegion = createClass({
    sName,
    tpNodes,
    tpAreaNodes,
    tpLinks
})

function CWorldmapRegion:get_name()
    return self.sName
end

function CWorldmapRegion:set_name(sName)
    self.sName = sName
end

function CWorldmapRegion:get_node(iNodeId)
    return self.tpNodes[iNodeId]
end

function CWorldmapRegion:get_nodes()
    return self.tpNodes
end

function CWorldmapRegion:set_nodes(tpNodes)
    self.tpNodes = tpNodes
end

function CWorldmapRegion:get_links()
    return self.tpLinks
end

function CWorldmapRegion:set_links(tpLinks)
    self.tpLinks = tpLinks
end

function CWorldmapRegion:make_remissive_index_area_region()
    self.tpAreaNodes = {}
    local m_tpAreaNodes = self.tpAreaNodes

    for iNodeid, pWmapNode in pairs(self.tpNodes) do
        local rgiMapids = pWmapNode:get_mapno_list()
        for _, iMapid in ipairs(rgiMapids) do
            m_tpAreaNodes[iMapid] = iNodeid
        end
    end
end

function CWorldmapRegion:get_node_by_mapid(iMapid)
    local m_tpAreaNodes = self.tpAreaNodes
    return m_tpAreaNodes[iMapid]
end
