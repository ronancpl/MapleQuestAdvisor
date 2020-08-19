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

function read_table(sFilePath, fn_split)
    local sFileContent = pcall_read_file(sFilePath)
    local aasRowValues = {}

    local asLines = split_line(sFileContent)
    for sLine in asLines do
        local asRowContent = fn_split(sLine)
        table.insert(aasRowValues, asRowContent)
    end

    return aasRowValues
end

function read_plain_table(sFilePath)
    local fn_split = splitText
    return read_table(sFilePath, fn_split)
end
