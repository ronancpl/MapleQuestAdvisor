--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("ui.constant.config")
require("ui.struct.window.frame.layer")
require("utils.struct.class")

CWndCanvas = createClass({
    rgpLayers = {}
})

function CWndCanvas:load(rgpLayerClass)
    local m_rgpLayers = self.rgpLayers

    if rgpLayerClass ~= nil then
        for _, pLyrClass in ipairs(rgpLayerClass) do
            local pLyr = pLyrClass:new()
            pLyr:load(RWndConfig.CAPACITY.CHANNELS)

            table.insert(m_rgpLayers, pLyr)
        end
    else
        local iLyrs = RWndConfig.CAPACITY.LAYERS
        for i = 1, iLyrs, 1 do
            local pLyr = CWndLayer:new()
            pLyr:load(RWndConfig.CAPACITY.CHANNELS)

            table.insert(m_rgpLayers, pLyr)
        end
    end
end

function CWndCanvas:build(pWmapProp)
    local m_rgpLayers = self.rgpLayers
    for _, pLyr in ipairs(m_rgpLayers) do
        pLyr:build(pWmapProp)
    end
end

function CWndCanvas:update(dt)
    local m_rgpLayers = self.rgpLayers
    for _, pLyr in ipairs(m_rgpLayers) do
        pLyr:update(dt)
    end
end

function CWndCanvas:draw()
    local m_rgpLayers = self.rgpLayers
    for _, pChn in ipairs(m_rgpLayers) do
        pChn:draw()
    end
end
