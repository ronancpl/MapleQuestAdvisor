--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("utils.logger.error")

LPath = {

    LOG_DIR = "logs/",

    QUEST_BOARD = "pool/",
    QUEST_PATH = "path/",
    FALLBACK = "digression/",
    OVERALL = "overall/",
    PROCEDURES = "procedures/"

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
