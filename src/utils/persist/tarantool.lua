--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

local tnt = require("resty.tarantool")

function tnt_new()
    local pCon, _ = tnt:new({
        host = '127.0.0.1',
        port = 3301,
        user = 'root',
        password = '',
        socket_timeout = 2000,
        call_semantics = 'new'
    })
    assert(pCon:connect())

    return pCon
end

function tnt_kv_add(pCon, sTable, rgpTuple)
    -- 1st element as primary key

    local pRes, _ = pCon:insert(sTable, rgpTuple)
    assert(pRes)
end

function tnt_kv_replace(pCon, sTable, rgpTuple)
    -- 1st element as primary key

    local pRes, _ = pCon:replace(sTable, rgpTuple)
    assert(pRes)
end

function tnt_kv_delete(pCon, sTable, pKey)
    local pRes, _ = pCon:delete(sTable, pKey)
    assert(pRes)
end

RSelectParam = {
    EQ = 0, -- equality
    REQ = 1, -- reverse equality
    ALL = 2, -- all tuples in an index
    LT = 3, -- less than
    LE = 4, -- less than or equal
    GE = 5, -- greater than or equal
    GT = 6, -- greater than
    BITSET_ALL_SET = 7, -- bits in the bitmask all set
    BITSET_ANY_SET = 8, -- any of the bist in the bitmask are set
    BITSET_ALL_NOT_SET = 9, -- none on the bits on the bitmask are set
}

function tnt_kv_fetch(pCon, sTable, sNode, pSlctPredicate, iIterOpt, tpOpts)
    tpOpts = tpOpts or {}
    tpOpts.iterator = iIterOpt

    local pRes, _ = pCon:select(sTable, sNode, pSlctPredicate, tpOpts)
    return pRes
end

function tnt_close(pCon)
    pCon:disconnect()
end
