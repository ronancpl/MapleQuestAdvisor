--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("ui.constant.view.resource")
require("ui.struct.component.canvas.resource.item.link")
require("ui.struct.component.canvas.resource.item.picture")

local function make_tab_resources_items(pRscProp)
    local rgpVwItems = {}

    for iId, iCount in pairs(pRscProp:get_info_item():get_items()) do
        local pVwItem = CCanvasRscPicture:new()
        pVwItem:load(pImg, iCount, sDesc, iFieldRef, RResourceTable.VW_GRID.W, RResourceTable.VW_GRID.H)

        table.insert(rgpVwItems, pVwItem)
    end

    return rgpVwItems
end

local function make_tab_resources_mobs(pRscProp)
    local rgpVwItems = {}

    for iId, iCount in pairs(pRscProp:get_info_mob():get_mobs()) do
        local pVwItem = CCanvasRscPicture:new()
        pVwItem:load(pImg, iCount, sDesc, iFieldRef, RResourceTable.VW_GRID.W, RResourceTable.VW_GRID.H)

        table.insert(rgpVwItems, pVwItem)
    end

    return rgpVwItems
end

local function make_tab_resources_npc(pRscProp)
    local rgpVwItems = {}

    local iId = pRscProp:get_info_npc():get_npc()

    local pVwItem = CCanvasRscPicture:new()
    pVwItem:load(pImg, iCount, sDesc, iFieldRef, RResourceTable.VW_PICT.W, RResourceTable.VW_PICT.H)

    table.insert(rgpVwItems, pVwItem)

    return rgpVwItems
end

local function make_tab_resources_field_enter(pRscProp)
    local rgpVwItems = {}

    local iId = pRscProp:get_info_field_enter():get_field()

    local pVwItem = CCanvasRscLink:new()
    pVwItem:load(sDesc, iFieldRef)

    table.insert(rgpVwItems, pVwItem)

    return rgpVwItems
end

function update_resource_items(pVwRscs, pRscProp)
    local tpVwItems = {}

    table.insert(tpVwItems, make_tab_resources_items(pRscProp))
    table.insert(tpVwItems, make_tab_resources_mobs(pRscProp))
    table.insert(tpVwItems, make_tab_resources_npc(pRscProp))
    table.insert(tpVwItems, make_tab_resources_field_enter(pRscProp))

    pVwRscs:clear_tab_items()
    for siTab, rgpVwItems in pairs(tpVwItems) do
        pVwRscs:add_tab_items(siTab, rgpVwItems)
    end
end
