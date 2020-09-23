--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("structs.quest.attributes.requirement")

local pDefaultAttrs = CQuestRequirement:new()    -- instances both CQuestRequirement and CQuestProperty

function is_player_have_strong_prerequisites(pPlayerState, pQuestProp)
    local pReqs = pQuestProp:get_requirement()

    for _, pReqAcc in pairs(tfn_strong_reqs) do
        local fn_req = pReqAcc:get_fn_pending()
        if fn_req(pReqAcc, pReqs, pPlayerState) > 0 then
            return false
        end
    end

    return true
end
