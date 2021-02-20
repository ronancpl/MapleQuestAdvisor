--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

function fn_is_attainable_list(fn_diff, pAcc)
    return function(pFrontierProp, pPlayerState)
        local tInvtDiff = fn_diff(pAcc, pFrontierProp, pPlayerState)
        return next(tInvtDiff) ~= nil and 0 or 1
    end
end

function fn_is_attainable_unit(fn_diff, pAcc)
    return function(pFrontierProp, pPlayerState)
        local iDiff = fn_diff(pAcc, pFrontierProp, pPlayerState)
        return iDiff > 0 and 0 or 1
    end
end
