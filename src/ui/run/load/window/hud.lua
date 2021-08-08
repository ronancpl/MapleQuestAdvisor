--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("ui.struct.window.frame.canvas.hud")

function load_interface_hud(pPlayer, pUiStats, pTrack, tRoute, tQuests, pUiWmap, pUiStats, pUiInvt, pUiRscs, pIvtItems, siExpRate, siMesoRate, siDropRate, sWmapName)
    local pUiHud = CWndHud:new()
    pUiHud:load(pPlayer, pUiStats, pTrack, tRoute, tQuests, pUiWmap, pUiStats, pUiInvt, pUiRscs, pIvtItems, siExpRate, siMesoRate, siDropRate, sWmapName)

    return pUiHud
end
