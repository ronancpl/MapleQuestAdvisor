--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("router.procedures.constant")
require("ui.struct.window.summary")
require("ui.struct.window.frame.layer")
require("utils.procedure.euclidean")
require("utils.struct.arrayset")
require("utils.struct.class")

CWmapNavMapLink = createClass({CWndLayer, {
    pSetLinkVisible = SArraySet:new(),
    iLastMx = U_INT_MAX,
    iLastMy = U_INT_MAX
}})

function CWmapNavMapLink:_build_element(pPropLink)
    local iChn = pPropLink:get_z() or 1
    self:add_element(iChn, pPropLink)
end

function CWmapNavMapLink:build(pWmapProp)
    self:reset()
    self.pSetLinkVisible:remove_all()

    -- add layer elements

    local rgpLinkNodes = pWmapProp:get_map_links()
    for _, pLinkNode in ipairs(rgpLinkNodes) do
        self:_build_element(pLinkNode)
    end
end

local function calc_link_distance(pLinkVisible, iMx, iMy)
    local iLx, iTy, iRx, iBy = pLinkVisible:get_object():get_ltrb()
    return calc_distance({iMx, (iLx + iRx) / 2, iMy, (iTy + iBy) / 2})
end

function CWmapNavMapLink:_sort_nearest_visible()
    local m_pSetLinkVisible = self.pSetLinkVisible

    local iMx, iMy = love.mouse.getPosition()

    local tiLinkDist = {}
    for _, pLink in ipairs(m_pSetLinkVisible:list()) do
        local iDist = calc_link_distance(pLink, iMx, iMy)
        tiLinkDist[pLink] = iDist
    end

    local fn_sort_by_dist = function (pLink1, pLink2)
        local iLinkDist1 = tiLinkDist[pLink1]
        local iLinkDist2 = tiLinkDist[pLink2]

        return iLinkDist1 > iLinkDist2
    end
    m_pSetLinkVisible:sort(fn_sort_by_dist)
end

function CWmapNavMapLink:_should_sort_visible()
    local iMx, iMy = love.mouse.getPosition()

    local bShouldSort = calc_distance({iMx, self.iLastMx, iMy, self.iLastMy})
    if bShouldSort then
        self.iLastMx = iMx
        self.iLastMy = iMy
    end

    return bShouldSort
end

function CWmapNavMapLink:before_update(dt)
    if self:_should_sort_visible() then
        self:_sort_nearest_visible()
    end

    local m_pSetLinkVisible = self.pSetLinkVisible
    local pLinkVisible = m_pSetLinkVisible:get(1)

    for _, pLinkNode in ipairs(self:get_elements(LChannel.LINK_IMG)) do
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

    self:_sort_nearest_visible()
end

function CWmapNavMapLink:remove_link_visible(pLinkVisible)
    local m_pSetLinkVisible = self.pSetLinkVisible
    m_pSetLinkVisible:remove(pLinkVisible)
end
