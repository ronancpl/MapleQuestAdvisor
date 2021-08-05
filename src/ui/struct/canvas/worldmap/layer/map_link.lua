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
require("ui.struct.component.element.plaintext")
require("ui.struct.window.summary")
require("ui.struct.window.frame.layer")
require("utils.procedure.euclidean")
require("utils.procedure.string")
require("utils.struct.arrayset")
require("utils.struct.class")

CWmapNavMapLink = createClass({CWndLayer, {
    pSetLinkVisible = SArraySet:new(),
    pLinkVisible,
    tpLinkFields = {},
    tFieldLink = {},
    iLastMx = U_INT_MAX,
    iLastMy = U_INT_MAX
}})

function CWmapNavMapLink:get_link_visible()
    return self.pLinkVisible
end

local function is_in_area(pElem, iLx, iTy, iRx, iBy)
    local iX, iY = pElem:get_object():get_center()
    return math.between(iX, iLx, iRx) and math.between(iY, iTy, iBy)
end

local function select_fields_in_region_link(pPropLink, pWmapProp)
    local iLx, iTy, iRx, iBy = pPropLink:get_object():get_ltrb()

    local rgpFieldNodes = {}
    for _, pFieldNode in ipairs(pWmapProp:get_map_fields()) do
        if is_in_area(pFieldNode, iLx, iTy, iRx, iBy) then
            table.insert(rgpFieldNodes, pFieldNode)
        end
    end

    return rgpFieldNodes
end

function CWmapNavMapLink:_build_element(pPropLink)
    local iChn = pPropLink:get_z() or 1
    self:add_element(iChn, pPropLink)
end

local function make_field_key(pField)
    local iVal = 0

    local iX, iY = pField:get_object():get_center()
    iVal = iVal + bit.lshift(iX, 0)
    iVal = iVal + bit.lshift(iY, 16)

    return iVal
end

function CWmapNavMapLink:_fetch_element_fields(pPropLink, pWmapProp)
    local m_tFieldLink = self.tFieldLink

    local iPx, iPy = pPropLink:get_object():get_center()

    local rgpFieldNodes = select_fields_in_region_link(pPropLink, pWmapProp)
    for _, pField in ipairs(rgpFieldNodes) do
        local iX, iY = pField:get_object():get_center()

        local iKeyField = make_field_key(pField)
        local iDist = calc_distance({iX, iPx, iY, iPy})

        local iCurDist
        local pLinkDist = m_tFieldLink[iKeyField]
        if pLinkDist ~= nil then
            _, _, iCurDist = unpack(pLinkDist)
        else
            iCurDist = U_INT_MAX
        end

        if iDist < iCurDist then
            m_tFieldLink[iKeyField] = {pField, pPropLink, iDist}
        end
    end
end

function CWmapNavMapLink:_make_remissive_index_link_fields()
    local m_tFieldLink = self.tFieldLink
    local m_tpLinkFields = self.tpLinkFields

    for _, pFieldLink in pairs(m_tFieldLink) do
        local pField
        local pLink
        pField, pLink, _ = unpack(pFieldLink)

        local rgpFields = create_inner_table_if_not_exists(m_tpLinkFields, pLink)
        table.insert(rgpFields, pField)
    end
end

function CWmapNavMapLink:build(pWmapProp)
    self:reset()
    self.pSetLinkVisible:remove_all()
    clear_table(self.tFieldLink)
    clear_table(self.tpLinkFields)

    -- add layer elements

    local rgpLinkNodes = pWmapProp:get_map_links()
    for _, pLinkNode in ipairs(rgpLinkNodes) do
        self:_build_element(pLinkNode)
        self:_fetch_element_fields(pLinkNode, pWmapProp)
    end

    self:_make_remissive_index_link_fields()
end

function CWmapNavMapLink:_calc_link_distance_center(pLinkVisible, iMx, iMy)
    local iLx, iTy, iRx, iBy = pLinkVisible:get_object():get_ltrb()

    local iDist = calc_distance({iMx, (iLx + iRx) / 2, iMy, (iTy + iBy) / 2})
    return iDist
end

function CWmapNavMapLink:_calc_link_distance_field_nearby(pLinkVisible, iMx, iMy)
    local iDist = U_INT_MAX

    local m_tpLinkFields = self.tpLinkFields
    local rgpFieldNodes = m_tpLinkFields[pLinkVisible]

    for _, pFieldNode in ipairs(rgpFieldNodes) do
        local iCx, iCy = pFieldNode:get_object():get_center()

        local iCurDist = calc_distance({iMx, iCx, iMy, iCy})
        iDist = math.min(iDist, iCurDist)
    end

    return iDist
end

function CWmapNavMapLink:_calc_link_distance(pLinkVisible, iMx, iMy)
    local iFieldDist = self:_calc_link_distance_field_nearby(pLinkVisible, iMx, iMy)
    local iCtrDist = self:_calc_link_distance_center(pLinkVisible, iMx, iMy)

    return math.min(iFieldDist, iCtrDist)
end

function CWmapNavMapLink:_sort_nearest_visible()
    local m_pSetLinkVisible = self.pSetLinkVisible

    local iMx, iMy = love.mouse.getPosition()
    local tiLinkDist = {}
    for _, pLink in ipairs(m_pSetLinkVisible:list()) do
        local iDist = self:_calc_link_distance(pLink, iMx, iMy)
        tiLinkDist[pLink] = iDist
    end

    local fn_sort_by_dist = function (pLink1, pLink2)
        local iLinkDist1 = tiLinkDist[pLink1]
        local iLinkDist2 = tiLinkDist[pLink2]

        return iLinkDist1 < iLinkDist2
    end
    m_pSetLinkVisible:sort(fn_sort_by_dist)
end

function CWmapNavMapLink:_should_sort_visible()
    local iMx, iMy = love.mouse.getPosition()

    local bShouldSort = calc_distance({iMx, self.iLastMx, iMy, self.iLastMy}) > 50
    if bShouldSort then
        self.iLastMx = iMx
        self.iLastMy = iMy
    end

    return bShouldSort
end

function CWmapNavMapLink:_select_next_link_visible()
    local iMx, iMy = love.mouse.getPosition()

    local m_pSetLinkVisible = self.pSetLinkVisible
    local tiLinkDist = {}
    for _, pLink in ipairs(m_pSetLinkVisible:list()) do
        tiLinkDist[pLink] = self:_calc_link_distance(pLink, iMx, iMy)
    end

    local iDist = U_INT_MAX
    local pLinkVisible = nil
    for _, pLink in pairs(m_pSetLinkVisible:list()) do
        local iLinkDist = tiLinkDist[pLink]
        if iLinkDist < iDist then
            iDist = iLinkDist
            pLinkVisible = pLink
        end
    end

    return pLinkVisible
end

function CWmapNavMapLink:_update_link_visible()
    self:_sort_nearest_visible()
    self.pLinkVisible = self:_select_next_link_visible()
end

function CWmapNavMapLink:before_update(dt)
    local pLyr = pUiWmap:get_layer(LLayer.NAV_WMAP_PTEXT)
    pLyr:reset_board()

    if self:_should_sort_visible() then
        self:_update_link_visible()
    end

    local m_pLinkVisible = self.pLinkVisible
    for _, pLinkNode in ipairs(self:get_elements(LChannel.WMAP_LINK_IMG)) do
        if pLinkNode == m_pLinkVisible then
            pLinkNode:visible()
        else
            pLinkNode:hidden()
        end
    end
end

function CWmapNavMapLink:add_link_visible(pLinkVisible)
    local m_pSetLinkVisible = self.pSetLinkVisible
    m_pSetLinkVisible:add(pLinkVisible)

    if self:_should_sort_visible() then
        self:_update_link_visible()
    end
end

function CWmapNavMapLink:remove_link_visible(pLinkVisible)
    local m_pSetLinkVisible = self.pSetLinkVisible

    local iIdx = m_pSetLinkVisible:remove(pLinkVisible)
    if iIdx ~= nil then
        if pLinkVisible == self:get_link_visible() then
            self:_update_link_visible()
        end
    end
end

function CWmapNavMapLink:is_link_visible(pLinkVisible)
    local m_pSetLinkVisible = self.pSetLinkVisible
    return m_pSetLinkVisible:contains(pLinkVisible)
end
