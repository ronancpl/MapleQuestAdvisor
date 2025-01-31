--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("ui.run.load.window.hud")

function load_frame_hud(pTrack, pPlayer, tRoute, tQuests, pUiWmap, pUiStats, pUiInvt, pUiRscs, siExpRate, siMesoRate, siDropRate)
    local pUiHud = load_interface_hud(pTrack, pPlayer, tRoute, tQuests, pUiWmap, pUiStats, pUiInvt, pUiRscs, siExpRate, siMesoRate, siDropRate)
    return pUiHud
end
