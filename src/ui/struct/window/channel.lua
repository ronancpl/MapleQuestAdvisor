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

CWndChannel = createClass({
    rgpRegisteredElements
})

function CWndChannel:load()
    self.rgpRegisteredElements = {}
end

function CWndChannel:update(dt)
    for _, pElem in ipairs(self.rgpRegisteredElements) do
        pElem:update(dt)
    end
end

function CWndChannel:draw()
    for _, pElem in ipairs(self.rgpRegisteredElements) do
        pElem:draw()
    end
end
