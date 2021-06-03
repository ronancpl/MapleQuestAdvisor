--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

local function open_rdbms_script(...)
    local sCmdRdbms = "lua5.1 ui/setup/persist/fetch.lua "

    local sArgs = ""
    for _, pItem in pairs(...) do
        sArgs = sArgs .. tostring(pItem)
    end

    local pHdl = io.popen(sCmdRdbms .. sArgs)
    return pHdl
end

local function collect_rdbms_result()
    local pRes = dofile("ui/setup/persist/fetch.lua")
    return pRes
end

function db_new(sDataSource)
    local pHdl = open_rdbms_script({sDataSource})
    return collect_rdbms_result()
end

function db_kv_add(pCon, pKey, pVal)
    local pHdl = open_rdbms_script({pCon, pKey, pVal})
    return collect_rdbms_result()
end

function db_kv_fetch(pCon, pKey)
    local pHdl = open_rdbms_script({pCon, pKey})
    return collect_rdbms_result()
end

function db_kv_delete(pCon, pKey)
    local pHdl = open_rdbms_script({pCon, pKey})
    return collect_rdbms_result()
end

function db_close(pCon, pEnv)
    local pHdl = open_rdbms_script({pCon, pEnv})
    return collect_rdbms_result()
end
