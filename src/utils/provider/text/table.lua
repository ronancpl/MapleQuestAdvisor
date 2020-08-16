--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("utils/io/file")
require("utils/io/wordlist")

function readTable(sFilePath, fn_split)
    local sFileContent = pcallReadFile(sFilePath)
    local tRowValues = {}

    local asLines = splitLine(sFileContent)
    for sLine in asLines do
        local asRowContent = fn_split(sLine)
        table.insert(tRowValues, asRowContent)
    end

    return tRowValues
end

function readPlainTable(sFilePath)
    local fn_split = splitText
    return readTable(sFilePath, fn_split)
end
