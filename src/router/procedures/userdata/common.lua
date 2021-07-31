--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("utils.provider.io.wordlist")

local function read_csv_lines_tonumber(sCsvPath)
    local rgpLines = {}

    local fIn = io.open(sCsvPath, "r")
    if fIn ~= nil then
        for sLine in fIn:lines() do
            local rgpLine = {}

            local rgsLineSp = split_csv(sLine)
            for _, pItem in pairs(rgsLineSp) do
                table.insert(rgpLine, tonumber(pItem) or pItem)
            end

            table.insert(rgpLines, rgpLine)
        end

        io.close(fIn)
    end

    return rgpLines
end

local function read_csv_lines_raw(sCsvPath)
    local rgsLines = {}

    local fIn = io.open(sCsvPath, "r")
    if fIn ~= nil then
        for sLine in fIn:lines() do
            local rgsLineSp = split_csv(sLine)
            table.insert(rgsLines, rgsLineSp)
        end

        io.close(fIn)
    end

    return rgsLines
end

function read_csv_lines(sCsvPath, bParseNumber)
    if bParseNumber then
        return read_csv_lines_tonumber(sCsvPath)
    else
        return read_csv_lines_raw(sCsvPath)
    end
end
