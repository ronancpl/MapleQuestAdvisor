--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

function string.starts_with(str, start_str)
    local i

    i, _ = string.find(str, "^" .. start_str)
    return i == 1
end

function string.ends_with(str, end_str)
    local i

    _, i = string.find(str, end_str .. "$")
    return i == string.len(str)
end

function string.rfind(str, match_str, idx)
    local i

    local r_str = str:reverse()
    local r_match = match_str:reverse()

    _, i = string.find(r_str, r_match, idx and (#str - idx) or 0)
    if i ~= nil then
        i = string.len(str) - i + 1     -- find from start
    end

    return i
end

function string.ltrb(iLx, iTy, iRx, iBy)
    return "(" .. iLx .. "," .. iTy .. " " .. iRx .. "," .. iBy .. ")"
end

function string.pad_number(iId, iLeftZero)
    local st = ""

    local bSign = iId < 0
    iId = math.abs(iId)

    local iAlg = iId > 0 and math.ceil(math.log(iId) / math.log(10)) or 0
    for i = 1, iLeftZero - iAlg, 1 do
        st = st .. "0"
    end

    return (bSign and "-" or "") .. st .. tostring(iId)
end
