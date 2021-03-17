--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("utils.procedure.unpack")
require("utils.struct.class")

CWndChannel = createClass({
    rgpRegisteredElements = {}
})

function CWndChannel:load()
    local m_rgpRegisteredElements = self.rgpRegisteredElements
    clear_table(m_rgpRegisteredElements)
end

function CWndChannel:update(dt)
    local m_rgpRegisteredElements = self.rgpRegisteredElements
    for _, pElem in ipairs(m_rgpRegisteredElements) do
        pElem:update(dt)
    end
end

function CWndChannel:draw()
    local m_rgpRegisteredElements = self.rgpRegisteredElements
    for _, pElem in ipairs(m_rgpRegisteredElements) do
        pElem:draw()
    end
end

function CWndChannel:add_element(pElem)
    local m_rgpRegisteredElements = self.rgpRegisteredElements
    table.insert(m_rgpRegisteredElements, pElem)
end

function CWndChannel:reset_elements()
    local m_rgpRegisteredElements = self.rgpRegisteredElements
    clear_table(m_rgpRegisteredElements)
end
