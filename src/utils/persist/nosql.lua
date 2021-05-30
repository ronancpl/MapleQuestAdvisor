--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("utils.persist.unqlite")

function nsql_new(sDataSource)
    return unq_new(sDataSource)
end

function nsql_kv_add(pCon, pKey, pVal)
    unq_kv_add(pCon, pKey, pVal)
end

function nsql_kv_delete(pCon, pKey)
    unq_kv_delete(pCon, pKey)
end

function nsql_kv_fetch(pCon, pKey)
    if pKey then
        local pData, pRes = unq_kv_fetch(pCon, pKey)
        return pData, pRes
    else
        local rgpData = unq_kv_fetch_all(pCon)
        return rgpData, true
    end
end

function nsql_commit(pCon)
    return unq_commit(pCon)
end

function nsql_close(pCon, pEnv)
    unq_close(pCon, pEnv)
end
