--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

local bit = require("bit")

local function xnor(btA, btB)
    local btGate1 = bit.bnot(bit.band(btA, btB))
    local btGate2 = bit.bor(btA, btB)

    return bit.band(btGate1, btGate2)
end

local function get_accessors_table(ctAccessors)
    return {ctAccessors.tfn_strong_reqs, ctAccessors.tfn_strong_ivt_reqs, ctAccessors.tfn_weak_reqs, ctAccessors.tfn_weak_ivt_reqs}
end

local function fetch_accessors_all(ctAccessors)
    local rgpAccs = {}
    for _, pAcc in ipairs(get_accessors_table(ctAccessors)) do
        table.insert(rgpAccs, pAcc)
    end

    return rgpAccs
end

local function get_block_table(bStrong, bInventory)
    local btBlock = bit.tobit(0)
    btBlock = bit.bor(btBlock, bit.lshift(bStrong and 0 or 1, 1))
    btBlock = bit.bor(btBlock, bit.lshift(bInventory and 0 or 1, 0))

    return btBlock
end

local function fetch_accessors_select(btBlock, ctAccessors)
    local rgpAccs = {}

    for i, pAcc in ipairs(get_accessors_table(ctAccessors)) do
        local iIdx = i - 1

        local btPass = bit.band(xnor(btBlock, iIdx), iIdx)
        if btPass > 0 then
            table.insert(rgpAccs, pAcc)
        end
    end

    return rgpAccs
end

function fetch_accessors(ctAccessors, bStrong, bInventory)  -- TODO: alter table to accept [nil, true, false] rather than boolean select
    local btBlock = get_block_table(bStrong, bInventory)
    if btBlock == 0 then
        return fetch_accessors_all(ctAccessors)
    else
        return fetch_accessors_select(btBlock, ctAccessors)
    end
end
