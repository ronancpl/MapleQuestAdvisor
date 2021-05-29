--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("utils.persist.packer")
require("utils.persist.tarantool")

function nsql_new()
    return tnt_new()
end

function nsql_kv_add(pCon, sTable, pVal)
    local rgpData = nsql_pack(pVal)
    tnt_kv_add(pCon, sTable, rgpData)
end

function nsql_kv_replace(pCon, sTable, pKey, pVal)
    local rgpData = nsql_pack(pVal, pKey)
    tnt_kv_replace(pCon, sTable, rgpData)
end

function nsql_kv_delete(pCon, sTable, pKey)
    tnt_kv_delete(pCon, sTable, pKey)
end

function nsql_kv_fetch(pCon, sTable, sNode, pSlctPredicate, sIter, pOpt)
    local rgpData = tnt_kv_fetch(pCon, sTable, sNode, pSlctPredicate, sIter, pOpt)

    local pData, pKey = nsql_unpack(rgpData)
    return pData, pKey
end

function nsql_close(pCon)
    tnt_close(pCon)
end
