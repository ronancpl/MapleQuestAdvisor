--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

local function splitDelimiter(sText, sDelimiter)
    local str = sText

    local asTokenList = {}
    for w in str:gmatch(sDelimiter) do
        table.insert(asTokenList, w)
    end

    return asTokenList
end

function splitText(sText)
    return splitDelimiter(sText, "(%w+)")
end

function splitLine(sText)
    return splitDelimiter(sText, "[^\r\n]+")
end

function splitCsv(sText)
    return splitDelimiter(sText, "[^,]+")
end
