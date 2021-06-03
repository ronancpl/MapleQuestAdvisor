--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("ui.setup.persist")
require("utils.persist.sqlite")

function rdbms_new(sDataSource)
    local pCon = sq3_new(sDataSource)
    return pCon
end

function rdbms_kv_add(pCon, pKey, pVal)
    local iId, pRes = sq3_kv_add(pCon, pKey, pVal)
    return iId, pRes
end

function rdbms_kv_delete(pCon, pKey)
    local pRes = sq3_kv_delete(pCon, pKey)
    return pRes
end

function rdbms_kv_fetch(pCon, pKey)
    if pKey ~= nil then
        local pData, pRes = sq3_kv_fetch(pCon, pKey)
        return pData, pRes
    else
        local rgpData = sq3_kv_fetch_all(pCon)
        return rgpData, true
    end
end

function rdbms_close(pCon)
    sq3_close(pCon)
end
