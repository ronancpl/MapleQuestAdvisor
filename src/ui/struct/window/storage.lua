--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("ui.run.load.interface.worldmap")
require("utils.provider.xml.provider")
require("utils.struct.class")

CWndStorage = createClass({
    tpWmapImgsCache = {},
    tpXmlWmapCache = {}
})

function CWndStorage:fetch_worldmap_region(sWmapName)
    local m_tpWmapImgsCache = self.tpWmapImgsCache

    local pXmlWmapNode
    local tpWmapImgs
    if m_tpWmapImgsCache[sWmapName] == nil then
        pXmlWmapNode, tpWmapImgs = load_frame_worldmap(sWmapName)

        local m_tpXmlWmapCache = self.tpXmlWmapCache

        m_tpXmlWmapCache[sWmapName] = pXmlWmapNode
        m_tpWmapImgsCache[sWmapName] = tpWmapImgs
    else
        tpWmapImgs = m_tpWmapImgsCache[sWmapName]
        pXmlWmapNode = m_tpXmlWmapNode[sWmapName]
    end

    return pXmlWmapNode, tpWmapImgs
end
