--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("ui.constant.path")
require("ui.struct.window.frame.channel")
require("utils.struct.class")

CWndLayer = createClass({
    rgpChannels = {}
})

function CWndLayer:load(nChns)
    local m_rgpChannels = self.rgpChannels

    for i = 1, nChns, 1 do
        local pChn = CWndChannel:new()
        table.insert(m_rgpChannels, pChn)
    end
end

function CWndLayer:update(dt)
    for _, pChn in ipairs(self.rgpChannels) do
        pChn:update(dt)
    end
end

function CWndLayer:draw()
    for _, pChn in ipairs(self.rgpChannels) do
        pChn:draw()
    end
end

function CWndLayer:onmousemoved(x, y, dx, dy, istouch)
    for _, pChn in ipairs(self.rgpChannels) do
        pChn:onmousemoved(x, y, dx, dy, istouch)
    end
end

function CWndLayer:onmousepressed(x, y, button)
    for _, pChn in ipairs(self.rgpChannels) do
        pChn:onmousepressed(x, y, button)
    end
end

function CWndLayer:onmousereleased(x, y, button)
    for _, pChn in ipairs(self.rgpChannels) do
        pChn:onmousereleased(x, y, button)
    end
end

function CWndLayer:add_element(iChn, pElem)
    local pChn = self.rgpChannels[iChn or 1]
    pChn:add_element(pElem)
end

function CWndLayer:add_elements(iChn, rgpElems)
    local pChn = self.rgpChannels[iChn]
    if pChn ~= nil then
        for _, pElem in ipairs(rgpElems) do
            pChn:add_element(pElem)
        end
    end
end

function CWndLayer:remove_element(iChn, pElem)
    local pChn = self.rgpChannels[iChn]
    if pChn ~= nil then
        pChn:remove_element(pElem)
    end
end

function CWndLayer:reset_elements(iChn)
    local pChn = self.rgpChannels[iChn]
    if pChn ~= nil then
        pChn:reset_elements()
    end
end

function CWndLayer:reset()
    for _, pChn in ipairs(self.rgpChannels) do
        pChn:reset_elements()
    end
end
