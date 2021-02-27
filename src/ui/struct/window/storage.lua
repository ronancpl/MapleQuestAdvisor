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

CWndStorage = createClass({
    tpWmapImgsCache = {},
    tpHelperQuadsCache,
    tpHelperImagesCache,
    tpWmapRegionCache = {}
})

function CWndStorage:_fetch_worldmap_helper()
    self.tpHelperQuadsCache, self.tpHelperImagesCache = load_frame_position_helper()
end

function CWndStorage:get_worldmap_helper()
    return self.tpHelperQuadsCache, self.tpHelperImagesCache
end

function CWndStorage:_fetch_worldmap_region(sWmapName, ctFieldsWmap)
    local m_tpWmapImgsCache = self.tpWmapImgsCache

    local pWmapRegion
    local tpWmapImgs
    if m_tpWmapImgsCache[sWmapName] == nil then
        pWmapRegion, tpWmapImgs = load_frame_worldmap_region(sWmapName, ctFieldsWmap)

        local m_tpWmapRegionCache = self.tpWmapRegionCache
        m_tpWmapRegionCache[sWmapName] = pWmapRegion
        m_tpWmapImgsCache[sWmapName] = tpWmapImgs
    else
        tpWmapImgs = m_tpWmapImgsCache[sWmapName]
        pWmapRegion = m_tpXmlWmapNode[sWmapName]
    end

    return pWmapRegion, tpWmapImgs
end

function CWndStorage:load_region(sWmapName)
    local pWmapRegion
    local tpWmapImgs
    pWmapRegion, tpWmapImgs = self:_fetch_worldmap_region(sWmapName, ctFieldsWmap)

    return pWmapRegion, tpWmapImgs
end

function CWndStorage:load()
    self:_fetch_worldmap_helper()
end
