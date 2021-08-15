--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("router.procedures.inventory.maker")

function fn_award_player_state_items(pPlayerState, rgpGet)
    local pItems = pPlayerState:get_items()

    local tpItems = table_copy(pItems:get_inventory():get_items())

    for iId, iGain in pairs(rgpGet:get_items()) do
        maker_add_item(pItems, iId, iGain)
    end

    for iId, iGain in pairs(tpItems) do
        maker_add_item(pItems, iId, iGain)
    end
end
