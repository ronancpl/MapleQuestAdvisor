--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

local json = require("json")

local function load_lua_pids(sFilePath)
    local tpPids = {}

    local fIn = assert( io.open(sFilePath, "r") )
    if fIn ~= nil then
        for sLine in fIn:lines() do
            local rgsArgs = json:decode("[" .. sLine .. "]")
            tpPids[rgsArgs[2]] = 1
        end

        fIn:close()
    end

    return tpPids
end

function fetch_popen_pid(sThenFilePath, sNowFilePath)
    local rgiPids = keys(table_intersection(load_lua_pids(sThenFilePath), load_lua_pids(sNowFilePath)))
    return rgiPids
end

function init_persist_interface()
    local sThenFilePath = "init.txt"

    os.execute("TASKLIST /fi \"IMAGENAME eq lua5.1.exe\" /nh /fo csv > " .. sThenFilePath)
    local pHdl = io.popen("lua5.1 utils/persist/act/start.lua")
end

function close_persist_interface()
    local sThenFilePath = "init.txt"
    local sNowFilePath = "end.txt"
    os.execute("TASKLIST /fi \"IMAGENAME eq lua5.1.exe\" /nh /fo csv > " .. sNowFilePath)

    local rgiPids = fetch_popen_pid(sNowFilePath, sThenFilePath)
    for _, iPid in ipairs(rgiPids) do
        os.execute("taskkill /F /IM " .. iPid)
    end

    os.remove(sNowFilePath)
    os.remove(sThenFilePath)
end
