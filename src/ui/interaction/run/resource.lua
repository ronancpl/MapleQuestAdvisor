--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

function on_mousemoved(x, y, dx, dy, istouch)
    pUiRscs:onmousemoved(x, y, dx, dy, istouch)
end

function on_mousepressed(x, y, button)
    pUiRscs:onmousepressed(x, y, button)
end

function on_mousereleased(x, y, button)
    pUiRscs:onmousereleased(x, y, button)
end

function on_wheelmoved(dx, dy)
    pUiRscs:onwheelmoved(dx, dy)
end
