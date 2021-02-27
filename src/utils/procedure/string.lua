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

function string.rfind(str, match_str)
    local i

    local r_str = str:reverse()
    local r_match = match_str:reverse()

    _, i = string.find(r_str, r_match)
    if i ~= nil then
        i = string.len(str) - i + 1     -- find from start
    end

    return i
end
