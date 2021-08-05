--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("utils.logger.error")

LPath = {

    LOG_DIR = "logs/",

    FALLBACK = "digression/",
    DB = "sql/",
    INTERFACE = "ui/",
    QUEST_BOARD = "pool/",
    QUEST_PATH = "path/",
    RESOURCE_LOCATION = "location/",
    OVERALL = "overall/",
    PROCEDURES = "procedures/",
    TRAJECTORY = "walk/"

}

local function fetch_catalog_name(sFileDir, sFileName)
    return LPath.LOG_DIR .. sFileDir .. os.date("%Y-%b-%d") .. "/", sFileName
end

local function fetch_log_line(...)
    local sLine = ""

    local args = {...}
    for _, sArg in ipairs(args) do
        sLine = sLine .. sArg .. "\t"
    end

    sLine:gsub("\t$", "")
    return sLine
end

function log(sFileDir, sFileName, ...)
    local sLogFilePath
    local sLogDirPath
    sLogDirPath, sLogFilePath = fetch_catalog_name(sFileDir, sFileName)

    sLogDirPath = pcall_log(sLogDirPath)
    local fOut = io.open(sLogDirPath .. "/" .. sLogFilePath, "a")

    local sLogLine = os.date("[%X] ") .. fetch_log_line(...)
    fOut:write(sLogLine)
    fOut:write("\r\n")

    if sFileDir == LPath.OVERALL then
        print(sLogLine)
    end

    io.close(fOut)
end

local function log_st_read_file(sLogFilePath)
    local rgsLines = {}

    local fIn = io.open(sLogFilePath, "r")
    if fIn ~= nil then
        for sLine in fIn:lines() do
            table.insert(rgsLines, sLine)
        end

        io.close(fIn)
    end

    return rgsLines
end

local function log_st_write(sLogFilePath, rgsLines)
    local fOut = io.open(sLogFilePath, "w")
    for _, sLine in ipairs(rgsLines) do
        fOut:write(sLine)
    end

    io.close(fOut)
end

function log_st(sFileDir, sFileName, ...)
    local sLogLine = fetch_log_line(...)

    local sLogFilePath
    local sLogDirPath
    sLogDirPath, sLogFilePath = fetch_catalog_name(sFileDir, sFileName)
    sLogDirPath = pcall_log(sLogDirPath)

    local sFilePath = sLogDirPath .. "/" .. sLogFilePath

    local rgsLines = log_st_read_file(sFilePath)
    table.insert(rgsLines, 1, os.date("[%X] ") .. sLogLine)
    table.insert(rgsLines, 2, "\r\n")

    log_st_write(sFilePath, rgsLines)

    if sFileDir == LPath.OVERALL then
        print(sLogLine)
    end
end
