--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

function fetch_accessor_remaining_requirement(pReqAcc, pPlayerState, pQuestChkProp)
    local fn_req = pReqAcc:get_fn_pending_property()

    local pRet = fn_req(pReqAcc, pQuestChkProp, pPlayerState)
    return pRet
end
