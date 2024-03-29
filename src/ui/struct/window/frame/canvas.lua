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

function CWndCanvas:build(pCanvasProp)
    local m_rgpLayers = self.rgpLayers
    for _, pLyr in ipairs(m_rgpLayers) do
        pLyr:build(pCanvasProp)
    end
end

function CWndCanvas:update(dt)
    local m_rgpLayers = self.rgpLayers
    for _, pLyr in ipairs(m_rgpLayers) do
        local fn_bfr_update = pLyr.before_update
        if fn_bfr_update ~= nil then
            fn_bfr_update(pLyr, dt)
        end

        pLyr:update(dt)
    end
end

function CWndCanvas:draw()
    local m_rgpLayers = self.rgpLayers
    for _, pLyr in ipairs(m_rgpLayers) do
        local fn_bfr_draw = pLyr.before_draw
        if fn_bfr_draw ~= nil then
            fn_bfr_draw(pLyr)
        end

        pLyr:draw()
    end
end

function CWndCanvas:onmousemoved(x, y, dx, dy, istouch)
    local m_rgpLayers = self.rgpLayers
    for _, pLyr in ipairs(m_rgpLayers) do
        pLyr:onmousemoved(x, y, dx, dy, istouch)
    end
end

function CWndCanvas:onmousepressed(x, y, button)
    local m_rgpLayers = self.rgpLayers
    for _, pLyr in ipairs(m_rgpLayers) do
        pLyr:onmousepressed(x, y, button)
    end
end

function CWndCanvas:onmousereleased(x, y, button)
    local m_rgpLayers = self.rgpLayers
    for _, pLyr in ipairs(m_rgpLayers) do
        pLyr:onmousereleased(x, y, button)
    end
end

function CWndCanvas:onwheelmoved(dx, dy)
    local m_rgpLayers = self.rgpLayers
    for _, pLyr in ipairs(m_rgpLayers) do
        pLyr:onwheelmoved(dx, dy)
    end
end

function CWndCanvas:hide_elements()
    local m_rgpLayers = self.rgpLayers
    for _, pLyr in ipairs(m_rgpLayers) do
        pLyr:hide_elements()
    end
end

function CWndCanvas:get_layer(iLayer)
    local m_rgpLayers = self.rgpLayers
    return m_rgpLayers[iLayer]
end

function CWndCanvas:reset()
    local m_rgpLayers = self.rgpLayers
    for _, pLyr in ipairs(m_rgpLayers) do
        pLyr:reset()
    end
end
