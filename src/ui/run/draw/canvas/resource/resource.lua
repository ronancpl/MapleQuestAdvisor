--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

function draw_resource_tooltip(pVwRsc)
    local pVwTip = pVwRsc:get_tooltip()

    local pTextbox = pVwTip:get_textbox()
    pTextbox:draw()
end

function draw_resource_link(pVwRsc)
    local eTxtDesc = pVwRsc:get_object_desc()
    eTxtDesc:draw()

    local eTxtFieldLink = pVwRsc:get_object_field_link()
    eTxtFieldLink:draw()
end

function draw_resource_picture(pVwRsc)
    if pVwRsc:is_visible_count() then
        local pImgRsc = pVwRsc:get_image()
        local iCount = pVwRsc:get_count()

        local iPx, iPy = pVwRsc:get_position()

        local pVwCnvRsc = load_item_canvas(pImgRsc, RResourceTable.VW_GRID.W, RResourceTable.VW_GRID.H)
        draw_item_canvas(pVwCnvRsc, iCount, iPx, iPy, RResourceTable.VW_GRID.W, RResourceTable.VW_GRID.H)
    end
end
