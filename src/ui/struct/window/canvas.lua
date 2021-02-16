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

CWndCanvas = createClass({
    rgpLayers
})

function CWndCanvas:load()
    self.rgpLayers = {}
end

function CWndCanvas:update(dt)
    for _, pLyr in ipairs(self.rgpLayers) do
        pLyr:update(dt)
    end
end

function CWndCanvas:draw()
    for _, pChn in ipairs(self.rgpLayers) do
        pChn:draw()
    end
end
