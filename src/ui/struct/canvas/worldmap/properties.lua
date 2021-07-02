--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("ui.run.build.canvas.worldmap.element.base_img")
require("ui.run.build.canvas.worldmap.element.map_link")
require("ui.run.build.canvas.worldmap.element.map_list")
require("ui.struct.path.pathing")
require("utils.procedure.copy")
require("utils.procedure.unpack")
require("utils.struct.class")

CWmapProperties = createClass({
    iCx = 0,
    iCy = 0,
    sParentMap,
    iWorldmapId,
    pBaseImg,
    rgpMapList = {},
    rgpMapLink = {},
    tpMapMarker = {},
    pTrack
})

function CWmapProperties:reset()
    self.sParentMap = nil
    self.pBaseImg = nil
    clear_table(self.rgpMapList)
    clear_table(self.rgpMapLink)
    clear_table(self.tpMapMarker)

    local pTrack = CTracePath:new()
    pTrack:load(pRouteLane)
    self.pTrack = pTrack
end

function CWmapProperties:get_parent_map()
    return self.sParentMap
end

function CWmapProperties:set_parent_map(sParentMap)
    self.sParentMap = sParentMap
end

function CWmapProperties:get_worldmap_id()
    return self.iWorldmapId
end

function CWmapProperties:set_worldmap_id(iWmapId)
    self.iWorldmapId = iWmapId
end

function CWmapProperties:set_base_img(pBaseImg)
    self.pBaseImg = pBaseImg
end

function CWmapProperties:get_base_img()
    return self.pBaseImg
end

function CWmapProperties:reset_map_links()
    clear_table(self.rgpMapLink)
end

function CWmapProperties:add_map_link(pLinkNode)
    table.insert(self.rgpMapLink, pLinkNode)
end

function CWmapProperties:get_map_links()
    return deep_copy(self.rgpMapLink)
end

function CWmapProperties:reset_map_fields()
    local m_rgpMapList = self.rgpMapList
    for _, pFieldNode in ipairs(m_rgpMapList) do
        pFieldNode:free()
    end

    clear_table(m_rgpMapList)
end

function CWmapProperties:add_map_field(pFieldNode)
    table.insert(self.rgpMapList, pFieldNode)

    local m_tpMapMarker = self.tpMapMarker

    local rgpMapnoNodes = pFieldNode:get_mapno()
    for _, iMapid in ipairs(rgpMapnoNodes) do
        m_tpMapMarker[iMapid] = pFieldNode
    end
end

function CWmapProperties:get_map_fields()
    return deep_copy(self.rgpMapList)
end

function CWmapProperties:get_marker_by_mapid(iMapid)
    return self.tpMapMarker[iMapid]
end

function CWmapProperties:get_markers()
    return self.tpMapMarker
end

function CWmapProperties:get_fields()
    return keys(self.tpMapMarker)
end

function CWmapProperties:get_origin()
    return self.iCx, self.iCy
end

function CWmapProperties:set_origin(iCx, iCy)
    self.iCx = iCx
    self.iCy = iCy
end

function CWmapProperties:get_track()
    return self.pTrack
end

function CWmapProperties:update_region(pWmapRegion, pDirHelperQuads, pDirWmapImgs, pUiRscs)
    self:reset()

    local pBaseImgNode = pWmapRegion:get_base_img()

    local pBgrd = load_node_worldmap_base_img(self, pBaseImgNode, pDirWmapImgs)
    self:set_base_img(pBgrd)

    local sWmapParent = pWmapRegion:get_parent_map()
    self:set_parent_map(sWmapParent)

    local sWmapRegion = pWmapRegion:get_name()

    self:reset_map_links()
    local tpLinks = pWmapRegion:get_links()
    for _, pPair in ipairs(spairs(tpLinks, function (a, b) return a < b end)) do
        local iIdx = pPair[1]
        local pMapLink = pPair[2]

        local pRegionLink = load_node_worldmap_map_link(self, pMapLink, pDirWmapImgs, sWmapRegion, iIdx)
        self:add_map_link(pRegionLink)
    end

    self:reset_map_fields()
    local tpNodes = pWmapRegion:get_nodes()
    for _, pPair in ipairs(spairs(tpNodes, function (a, b) return a < b end)) do
        local iIdx = pPair[1]
        local pMapNode = pPair[2]

        local pRegionMarker = load_node_worldmap_map_list(self, pUiRscs, pMapNode, pDirHelperQuads, pDirWmapImgs, sWmapRegion, iIdx)
        self:add_map_field(pRegionMarker)
    end
end
