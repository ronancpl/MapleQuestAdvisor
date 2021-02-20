--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

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

local function get_allow_table(bStrong, bInventory)
    local btAllow = bit.tobit(0)
    btAllow = bit.bor(btAllow, bit.lshift(bStrong == true and 1 or 0, 1))
    btAllow = bit.bor(btAllow, bit.lshift(bInventory == true and 1 or 0, 0))

    local btDontCare = bit.tobit(0)
    btDontCare = bit.bor(btDontCare, bit.lshift(bStrong == nil and 0 or 1, 1))
    btDontCare = bit.bor(btDontCare, bit.lshift(bInventory == nil and 0 or 1, 0))

    return btAllow, btDontCare
end

local function fetch_accessors_select(btAllow, btDontCare, ctAccessors)
    local rgpAccs = {}

    for i, tpTableAccs in ipairs(get_accessors_table(ctAccessors)) do
        local iIdx = i - 1

        local btPass = xnor(btAllow, iIdx)
        if bit.band(btPass, btDontCare) <= 0 then
            for _, pAcc in pairs(tpTableAccs) do
                table.insert(rgpAccs, pAcc)
            end
        end
    end

    return rgpAccs
end

function fetch_accessors(ctAccessors, bStrong, bInventory)
    local btAllow, btDontCare = get_allow_table(bStrong, bInventory)
    return fetch_accessors_select(btAllow, btDontCare, ctAccessors)
end
