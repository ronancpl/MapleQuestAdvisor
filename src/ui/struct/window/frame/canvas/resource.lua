--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("solver.lookup.constant")
require("ui.struct.canvas.resource.properties")
require("ui.struct.canvas.resource.layer.item")
require("ui.struct.canvas.resource.layer.table")
require("ui.struct.component.canvas.resource.table")
require("ui.struct.component.element.texture")
require("utils.struct.class")

CWndResource = createClass({
    pCanvas = CWndCanvas:new(),
    pProp = CRscProperties:new()
})

function CWndResource:get_properties()
    return self.pProp
end

function CWndResource:_fetch_field_resources(pQuestProp, rgiResourceids)
    local tiItems = {}
    local tiMobs = {}
    local iNpc = nil
    local tFieldsEnter = {}

    local pQuestChkProp = pQuestProp:get_requirement()

    local tpItems = pQuestChkProp:get_items():get_items()
    local tpMobs = pQuestChkProp:get_mobs():get_items()

    for _, iRscid in ipairs(rgiResourceids) do
        local iRscType = math.floor(iRscid / 1000000000)
        local iRscUnit = iRscid % 1000000000

        if iRscType == RLookupCategory.MOBS then
            tiMobs[iRscUnit] = tpMobs[iRscUnit]
        elseif iRscType == RLookupCategory.ITEMS then
            tiItems[iRscUnit] = tpItems[iRscUnit]
        elseif iRscType == RLookupCategory.FIELD_ENTER then
            tFieldsEnter[iRscUnit] = 1
        elseif iRscType == RLookupCategory.FIELD_NPC then
            iNpc = iRscUnit
        end
    end

    return tiItems, tiMobs, iNpc, tFieldsEnter
end

function CWndResource:_add_resources(pQuestProp, pRscTree)
    local m_pProp = self.pProp

    for iMapid, pResource in pairs(pRscTree:get_field_nodes()) do
        local rgiResourceids = pResource:get_resources()

        local tiItems, tiMobs, iNpc, tFieldsEnter = self:_fetch_field_resources(pQuestProp, rgiResourceids)
        m_pProp:add_field_resources(iMapid, tiItems, tiMobs, iNpc, tFieldsEnter)
    end
end

function CWndResource:update_resources(pQuestProp, pRscTree)
    self.pCanvas:reset()

    self:_add_resources(pQuestProp, pRscTree)

    local m_pProp = self.pProp
    m_pProp:set_resource_tree(pRscTree)

    m_pProp:build()

    self.pCanvas:build(m_pProp)

    local pVwRscs = m_pProp:get_table()
    local fn_update_items = pVwRscs:get_fn_update_items()
    fn_update_items(pVwRscs, m_pProp)
end

function CWndResource:get_field_resources()
    local tpFieldRscs = {}

    local m_pProp = self.pProp
    local rgiMapids = m_pProp:get_fields()

    for _, iMapid in pairs(rgiMapids) do
        local pRscEntry = m_pProp:get_field_resources(iMapid)
        tpFieldRscs[iMapid] = pRscEntry
    end

    return tpFieldRscs[iMapid]
end

function CWndResource:set_dimensions(iWidth, iHeight)
    self.pCanvas:reset()

    local m_pProp = self.pProp
    local eTexture = m_pProp:get_table():get_background()

    eTexture:build(iWidth, iHeight)

    self.pCanvas:build(m_pProp)
end

function CWndResource:_load_table()
    local pTextureDataBgrd = ctVwRscs:get_background_data()

    local pVwRscs = CRscTableElem:new()
    pVwRscs:load(0, 0, pTextureDataBgrd)

    pVwRscs:set_tab_selected(1)

    self.pProp:set_table(pVwRscs)
end

function CWndResource:load()
    self:_load_table()
    self.pCanvas:load({CResourceNavTable, CResourceNavItems}) -- follows sequence: LLayer
end

function CWndResource:update(dt)
    self.pCanvas:update(dt)
end

function CWndResource:draw()
    self.pCanvas:draw()
end

function CWndResource:onmousemoved(x, y, dx, dy, istouch)
    self.pCanvas:onmousemoved(x, y, dx, dy, istouch)
end

function CWndResource:onmousepressed(x, y, button)
    self.pCanvas:onmousepressed(x, y, button)
end

function CWndResource:onmousereleased(x, y, button)
    self.pCanvas:onmousereleased(x, y, button)
end

function CWndResource:onwheelmoved(dx, dy)
    self.pCanvas:onwheelmoved(dx, dy)
end

function CWndResource:get_layer(iLayer)
    return self.pCanvas:get_layer(iLayer)
end
