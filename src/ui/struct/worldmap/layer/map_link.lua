--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("ui.struct.window.frame.layer")
require("utils.struct.arrayset")
require("utils.struct.class")

CWmapNavMapLink = createClass({CWndLayer, {
    pSetLinkVisible = SArraySet:new()
}})

function CWmapNavMapLink:_build_element(pPropLink)
    local iChn = pPropLink:get_z() or 1
    self:add_element(iChn, pPropLink)
end

function CWmapNavMapLink:build(pWmapProp)
    self:reset()

    -- add layer elements

    local rgpLinkNodes = pWmapProp:get_map_links()
    for _, pLinkNode in ipairs(rgpLinkNodes) do
        self:_build_element(pLinkNode)
    end

end

function CWmapNavMapLink:before_update(dt)
    local pLinkVisible = self.pSetLinkVisible:get(0)

    for _, pLinkNode in ipairs(self:get_elements(iChn)) do
        if pLinkNode == pLinkVisible then
            pLinkNode:visible()
        else
            pLinkNode:hidden()
        end
    end
end

function CWmapNavMapLink:add_link_visible(pLinkVisible)
    local m_pSetLinkVisible = self.pSetLinkVisible
    m_pSetLinkVisible:add(pLinkVisible)
end

function CWmapNavMapLink:remove_link_visible(pLinkVisible)
    local m_pSetLinkVisible = self.pSetLinkVisible
    m_pSetLinkVisible:remove(pLinkVisible)
end
