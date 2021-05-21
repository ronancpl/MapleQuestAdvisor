--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("ui.run.update.canvas.position")

function draw_slider(pVwButton)
    local iPx
    local iPy
    iPx, iPy = read_canvas_position()

    local iRx
    local iRy
    iRx, iRy = pVwButton:get_origin()

    local pImgBase = pVwButton:get_base()
    love.graphics.draw(pImgBase, iPx + iRx, iPy + iRy)
end
