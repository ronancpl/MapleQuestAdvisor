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
    local sCmdRdbms = "lua5.1 utils/persist/act/fetch.lua"

    local sArgs = ""
    for _, pItem in pairs(...) do
        sArgs = sArgs .. tostring(pItem)
    end

    local pHdl = io.popen(sCmdRdbms .. " " .. sArgs)
    return pHdl
end

local function collect_rdbms_result()
    local pRes = dofile("utils/persist/act/collect.lua")
    return pRes
end

function db_new(sDataSource)
    log_st(LPath.DB, "_new.txt", " new '" .. sDataSource .. "'")
    local pHdl = open_rdbms_script({sDataSource})
    return collect_rdbms_result()
end

function db_kv_add(pCon, pKey, pVal)
    log_st(LPath.DB, "_new.txt", " add '" .. tostring(pKey) .. "' " .. tostring(pVal))
    local pHdl = open_rdbms_script({nil, pKey, pVal})
    return collect_rdbms_result()
end

function db_kv_fetch(pCon, pKey)
    log_st(LPath.DB, "_new.txt", " ftc '" .. tostring(pKey) .. "'")
    local pHdl = open_rdbms_script({nil, pKey})     -- interface has connection assigned
    return collect_rdbms_result()
end

function db_kv_delete(pCon, pKey)
    log_st(LPath.DB, "_new.txt", " del '" .. tostring(pKey) .. "'")
    local pHdl = open_rdbms_script({nil, pKey})

    return collect_rdbms_result()
end

function db_close(pCon)
    log_st(LPath.DB, "_new.txt", " close '" .. tostring(pCon) .. "'")
    local pHdl = open_rdbms_script({nil})
    return collect_rdbms_result()
end
