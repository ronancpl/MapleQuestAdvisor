--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

LPath = {

    FALLBACK = "digression/",
    OVERALL = "overall/",
    PROCEDURES = "procedures/"

}

local function create_directory_if_not_exists(sPath)
    local response = os.execute("cd " .. sPath)
    print(response)
    os.execute("pause")

    if response ~= 0 then
        os.execute("mkdir " .. sPath)
    end
end

local function fetch_catalog_name(sFileDir, sFileName)
    return sFileDir .. os.date("%Y-%b-%d") .. "/" .. sFileName .. ".txt"
end

local function fetch_log_line(...)
    local sLine = ""

    if type(...) == "table" then
        for _, sArg in ipairs(...) do
            sLine = sLine .. sArg .. "\t"
        end
    else
        sLine = ...
    end

    sLine:gsub("\t$", "")
    return sLine
end

function log(sFileDir, sFileName, ...)
    create_directory_if_not_exists(sFileDir)

    local sFilePath = fetch_catalog_name(sFileDir, sFileName)
    local fOut = io.open(sFilePath,'a')

    local sLogLine = os.date("[%X] ") .. fetch_log_line(...)
    fOut:write(sLogLine)
    print(sLogLine)

    io.close(fOut)
end
