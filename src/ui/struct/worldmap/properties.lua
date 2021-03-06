--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("ui.run.build.worldmap.element.base_img")
require("ui.run.build.worldmap.element.map_link")
require("ui.run.build.worldmap.element.map_list")
require("utils.procedure.copy")
require("utils.procedure.unpack")
require("utils.struct.class")

CWmapProperties = createClass({
    sParentMap,
    pBaseImg,
    rgpMapList = {},
    rgpMapLink = {}
})

function CWmapProperties:reset()
    self.sParentMap = nil
    self.pBaseImg = nil
    clear_table(self.rgpMapList)
    clear_table(self.rgpMapLink)
end

function CWmapProperties:get_parent_map()
    return self.sParentMap
end

function CWmapProperties:set_parent_map(sParentMap)
    self.sParentMap = sParentMap
end

function CWmapProperties:set_base_img(pBaseImg)
    self.pBaseImg = pBaseImg
end

function CWmapProperties:get_base_img()
    return self.pBaseImg
end

function CWmapProperties:add_map_link(pLinkNode)
    table.insert(self.rgpMapLink, pLinkNode)
end

function CWmapProperties:get_map_links()
    return deep_copy(self.rgpMapLink)
end

function CWmapProperties:add_map_field(pFieldNode)
    table.insert(self.rgpMapList, pFieldNode)
end

function CWmapProperties:get_map_fields()
    return deep_copy(self.rgpMapList)
end

function CWmapProperties:update_region(pWmapRegion, pDirHelperImgs, pDirWmapImgs)
    local pBaseImgNode = pWmapRegion:get_base_img()
    local pImgBase = load_node_worldmap_base_img(pBaseImgNode, pDirWmapImgs)
    self:set_base_img(pImgBase)

    local sWmapParent = pWmapRegion:get_parent_map()
    self:set_parent_map(sWmapParent)

    local sWmapRegion = pWmapRegion:get_name()

    local tpLinks = pWmapRegion:get_links()
    for _, pPair in ipairs(spairs(tpLinks, function (a, b) return a < b end)) do
        local iIdx = pPair[1]
        local pMapLink = pPair[2]

        local pRegionLink = load_node_worldmap_map_link(pMapLink, pDirWmapImgs, sWmapRegion, iIdx)
        self:add_map_link(pRegionLink)
    end

    local tpNodes = pWmapRegion:get_nodes()
    for _, pPair in ipairs(spairs(tpNodes, function (a, b) return a < b end)) do
        local iIdx = pPair[1]
        local pMapNode = pPair[2]

        local pRegionMarker = load_node_worldmap_map_list(pMapNode, pDirHelperImgs, pDirWmapImgs, sWmapRegion, iIdx)
        self:add_map_field(pRegionMarker)
    end
end
