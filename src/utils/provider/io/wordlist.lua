--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

local function split_delimiter(sText, sDelimiter)
    local str = sText

    local asTokenList = {}
    for w in str:gmatch(sDelimiter) do
        table.insert(asTokenList, w)
    end

    return asTokenList
end

function split_text(sText)
    return split_delimiter(sText, "(%S+)")
end

function split_line(sText)
    return split_delimiter(sText, "[^\r\n]+")
end

function split_csv(sText)
    return split_delimiter(sText, "[^,]+")
end

function split_path(sText)
    return split_delimiter(sText, "[^/\\]+")
end
