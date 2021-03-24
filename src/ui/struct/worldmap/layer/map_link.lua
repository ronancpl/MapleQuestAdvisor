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
require("utils.struct.arrayset")
require("utils.struct.class")

CWmapNavMapLink = createClass({CWndLayer, {
    pSetLinkVisible = SArraySet:new(),
    tpLinkFields = {},
    iLastMx = U_INT_MAX,
    iLastMy = U_INT_MAX
}})

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

function CWmapNavMapLink:_build_element(pPropLink, pWmapProp)
    local iChn = pPropLink:get_z() or 1
    self:add_element(iChn, pPropLink)

    local m_tpLinkFields = self.tpLinkFields
    local rgpFieldNodes = select_fields_in_region_link(pPropLink, pWmapProp)
    m_tpLinkFields[pPropLink] = rgpFieldNodes
end

function CWmapNavMapLink:build(pWmapProp)
    self:reset()
    self.pSetLinkVisible:remove_all()

    -- add layer elements

    local rgpLinkNodes = pWmapProp:get_map_links()
    for _, pLinkNode in ipairs(rgpLinkNodes) do
        self:_build_element(pLinkNode, pWmapProp)
    end
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
        local iLx, iTy, iRx, iBy = pFieldNode:get_object():get_ltrb()
        iDist = math.min(iDist, calc_distance({iMx, (iLx + iRx) / 2, iMy, (iTy + iBy) / 2}))
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

        if iLinkDist1 == nil or iLinkDist2 == nil then
            local iLx1, iRx1
            local iTy1, iBy1
            iLx1, iTy1, iRx1, iBy1 = pLink1:get_object():get_ltrb()

            local iLx2, iRx2
            local iTy2, iBy2
            iLx2, iTy2, iRx2, iBy2 = pLink2:get_object():get_ltrb()

            local st = "COMPR (" .. tostring(iLx1) .. "," .. tostring(iTy1) .. " " .. tostring(iRx1) .. "," .. tostring(iBy1) .. ")|(" .. tostring(iLx2) .. "," .. tostring(iTy2) .. " " .. tostring(iRx2) .. "," .. tostring(iBy2) .. ")"
            log_st(LPath.INTERFACE, "_link.txt", st)
        end

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
    local pLyr = pUiWmap:get_layer(LLayer.NAV_PTEXT)

    local iMx, iMy = love.mouse.getPosition()

    local m_pSetLinkVisible = self.pSetLinkVisible
    local tiLinkDist = {}
    for _, pLink in ipairs(m_pSetLinkVisible:list()) do
        local iDist = self:_calc_link_distance(pLink, iMx, iMy)
        tiLinkDist[pLink] = iDist
    end

    pLyr:reset()
    local st = "M:" .. iMx .. " " .. iMy .. " s:" .. #m_pSetLinkVisible:list()
    pLyr:add_text_element(st)

    if #m_pSetLinkVisible:list() > 0 then
        for _, pLink in pairs(m_pSetLinkVisible:list()) do
            local iLx, iRx
            local iTy, iBy
            iLx, iTy, iRx, iBy = pLink:get_object():get_ltrb()

            local iX, iY = pLink:get_object():get_center()

            local st = tiLinkDist[pLink] .. " (" .. iLx .. "," .. iTy .. ") (" .. iRx .. "," .. iBy .. ") C:" .. iX .. "," .. iY .. ""
            pLyr:add_text_element(st)
        end

        local pFontTitle = love.graphics.newFont(RWndPath.LOVE_FONT_DIR_PATH .. "arial.ttf", 12)
    end

    for i = 1, m_pSetLinkVisible:size(), 1 do
        local pLinkVisible = m_pSetLinkVisible:get(i)
        return pLinkVisible
    end

    return nil
end

function CWmapNavMapLink:before_update(dt)
    local pLyr = pUiWmap:get_layer(LLayer.NAV_PTEXT)
    pLyr:reset_board()

    if self:_should_sort_visible() then
        self:_sort_nearest_visible()
    end

    local m_pSetLinkVisible = self.pSetLinkVisible
    local pLinkVisible = self:_select_next_link_visible()

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

    local iLx, iTy, iRx, iBy = pLinkVisible:get_object():get_ltrb()
    log_st(LPath.INTERFACE, "_hover.txt", "")
    local st = "ADD >> " .. "(" .. iLx .. "," .. iTy .. " " .. iRx .. "," .. iBy .. "), "
    log_st(LPath.INTERFACE, "_hover.txt", st)
end

function CWmapNavMapLink:remove_link_visible(pLinkVisible)
    local m_pSetLinkVisible = self.pSetLinkVisible
    m_pSetLinkVisible:remove(pLinkVisible)

    local iLx, iTy, iRx, iBy = pLinkVisible:get_object():get_ltrb()
    log_st(LPath.INTERFACE, "_hover.txt", "")
    local st = "RMV >> " .. "(" .. iLx .. "," .. iTy .. " " .. iRx .. "," .. iBy .. "), "
    log_st(LPath.INTERFACE, "_hover.txt", st)
end

function CWmapNavMapLink:debug_link_visible()
    local m_pSetLinkVisible = self.pSetLinkVisible

    local st = ">> "
    for _, pLink in ipairs(m_pSetLinkVisible:list()) do
        local iLx, iTy, iRx, iBy = pLink:get_object():get_ltrb()
        st = st .. "(" .. iLx .. "," .. iTy .. " " .. iRx .. "," .. iBy .. "), "
    end
    log_st(LPath.INTERFACE, "_hover.txt", st)
end
