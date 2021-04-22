--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("ui.run.load.interface.position")
require("ui.run.load.interface.worldmap")
require("utils.provider.xml.provider")
require("utils.struct.class")

CWmapStorage = createClass({
    pDirWmapImgs = {},
    tpWmapRegionCache = {},
    pDirHelperQuads,
    pDirHelperImgs
})

function CWmapStorage:_fetch_worldmap_helper()
    self.pDirHelperQuads, self.pDirHelperImgs = load_frame_position_helper()
end

function CWmapStorage:get_worldmap_helper()
    return self.pDirHelperQuads, self.pDirHelperImgs
end

function CWmapStorage:_fetch_worldmap_region(sWmapName, ctFieldsWmap)
    local m_pDirWmapImgs = self.pDirWmapImgs
    local m_tpWmapRegionCache = self.tpWmapRegionCache

    local pWmapRegion
    local pDirWmapImgs
    if m_pDirWmapImgs[sWmapName] == nil then
        pWmapRegion, pDirWmapImgs = load_frame_worldmap_region(sWmapName, ctFieldsWmap)

        m_tpWmapRegionCache[sWmapName] = pWmapRegion
        m_pDirWmapImgs[sWmapName] = pDirWmapImgs
    else
        pDirWmapImgs = m_pDirWmapImgs[sWmapName]
        pWmapRegion = m_tpWmapRegionCache[sWmapName]
    end

    return pWmapRegion, pDirWmapImgs
end

function CWmapStorage:load_region(sWmapName)
    local pWmapRegion
    local pDirWmapImgs
    pWmapRegion, pDirWmapImgs = self:_fetch_worldmap_region(sWmapName, ctFieldsWmap)

    return pWmapRegion, pDirWmapImgs
end

function CWmapStorage:load()
    self:_fetch_worldmap_helper()
end
