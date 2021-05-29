--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

math.randomseed(os.time())

local function nsql_gen_key()
    return math.random()
end

function nsql_pack(sVal, sKey)
    local rgpTuple = {sKey or nsql_gen_key(), 0, sVal}
    return rgpTuple
end

function nsql_unpack(rgpTuple)
    return rgpTuple[3], rgpTuple[1]
end
