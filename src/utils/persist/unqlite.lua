--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

local driver = require("luanosql.unqlite")

function unq_new(sDataSource)
    local pEnv = assert (driver.unqlite())

    -- connect to unqlite data source
    local pCon = assert (pEnv:connect(sDataSource))

    return pEnv, pCon
end

function unq_kv_add(pCon, pKey, pVal)
    return assert (pCon:kvstore(pKey, pVal))
end

function unq_kv_delete(pCon, pKey)
    return assert (pCon:kvdelete(pKey))
end

function unq_kv_fetch(pCon, pKey)
    local pRes, pData = pCon:kvfetch(pKey)
    return pData, assert (pRes)
end

function unq_kv_fetch_all(pCon)
    -- create a pCursor
    local pCur = pCon:create_cursor()

    local tpItems = {}
    repeat
        if pCur:is_valid_entry() then
            tpItems[pCur:cursor_key()] = pCur:cursor_data()
        end
    until pCur:next_entry()

    assert(pCur:release())

    return tpItems
end

function unq_commit(pCon)
    return assert(pCon:commit())
end

function unq_close(pCon, pEnv)
    pCon:close()
    pEnv:close()
end
