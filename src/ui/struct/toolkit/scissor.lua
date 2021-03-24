--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

function lock_drawable_area(x, y, width, height, bDrawTrace)
    love.graphics.setScissor(x, y, width, height)

    if bDrawTrace then
        love.graphics.setColor(0, 0, 1)
        love.graphics.rectangle("fill", x, y, width, height)
    end
end

function unlock_drawable_area()
    love.graphics.setColor(1, 1, 1)
    love.graphics.setScissor()
end

function clear_drawable_area(x, y, width, height, bDrawTrace)
    love.graphics.setScissor(x, y, width, height)
    --love.graphics.clear()

    if bDrawTrace then
        love.graphics.setColor(0, 1, 0)
        love.graphics.rectangle("fill", x, y, width, height)
    end

    love.graphics.setScissor()
    love.graphics.setColor(1, 1, 1)
end
