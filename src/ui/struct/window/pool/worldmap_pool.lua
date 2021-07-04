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
require("utils.struct.pool")

CPoolWorldmap = createClass({

    pPool = CPool:new()

})

local function get_key_table_image(pPair, pWmapProp, pDirHelperQuads, pDirWmapImgs, sWmapRegion)
    return pPair
end

local function fn_create_item(pPair, pWmapProp, pDirHelperQuads, pDirWmapImgs, sWmapRegion)
    local iIdx = pPair[1]
    local pMapNode = pPair[2]

    local pRegionMarker = load_node_worldmap_map_list(pWmapProp, pUiRscs, pMapNode, pDirHelperQuads, pDirWmapImgs, sWmapRegion, iIdx)
    return pRegionMarker
end

function CPoolWorldmap:init()
    self.pPool:load(get_key_table_image, fn_create_item)
end

function CPoolWorldmap:take_region(pPair, pWmapProp, pDirHelperQuads, pDirWmapImgs, sWmapRegion)
    local m_pPool = self.pPool
    return m_pPool:take_object({pPair, pWmapProp, pDirHelperQuads, pDirWmapImgs, sWmapRegion})
end

function CPoolWorldmap:put_region(pRegionMarker, pPair, pWmapProp, pDirHelperQuads, pDirWmapImgs, sWmapRegion)
    local m_pPool = self.pPool
    m_pPool:put_object(pRegionMarker, {pPair, pWmapProp, pDirHelperQuads, pDirWmapImgs, sWmapRegion})
end
