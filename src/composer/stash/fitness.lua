--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("router.constants.quest")

local function calc_single_fitness(pTypeFit, sTypeTag)
    local iTypeBoost = pTypeFit[sTypeTag]
    return iTypeBoost
end

local function calc_type_fitness(rgpTypeFit, sTypeTag, iType, iCount)
    local pTypeFit = rgpTypeFit[iType]

    local iRet
    if pTypeFit ~= nil then
        local iTypeMult = calc_single_fitness(pTypeFit, sTypeTag)
        iRet = (iCount * iTypeMult)
    else
        iRet = 0.0
    end

    return iRet
end

local rgpTypeFit = {RQuest.ITEMS.EQUIP, RQuest.ITEMS.USE, RQuest.ITEMS.SETUP, RQuest.ITEMS.ETC}
local sFitType = "Boost"

function calc_item_fitness(iId, iCount)
    local iType = math.floor(iId / 1000000)

    local iValue = calc_type_fitness(rgpTypeFit, sFitType, iType, iCount)
    return iValue
end
