--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

local function fetch_effective_unit_count_to_item(iId, iCount, pPlayerState)
    local iRegionid = ctFieldsLandscape:get_region_by_mapid(pPlayerState:get_mapid())

    local fChance = ctRetrieveLootMobs:get_acquisition_chance(iId, iRegionid)
    fChance = math.max(fChance, ctRetrieveLootReactors:get_acquisition_chance(iId, iRegionid))
    fChance = fChance + 0.001

    return math.ceil(iCount * (1.0 / fChance))
end

function fetch_effective_unit_count_to_inventory(tiItems, pPlayerState)
    local tiEffItems = {}
    for iId, iCount in pairs(tiItems) do
        tiEffItems[iId] = fetch_effective_unit_count_to_item(iId, iCount, pPlayerState)
    end

    return tiEffItems
end

function fetch_inventory_split_count(tiItems)
    local tiTypeCount = {}

    for iId, iCount in pairs(tiItems) do
        local iType = math.floor(iId / 1000000)
        tiTypeCount[iType] = (tiTypeCount[iType] or 0) + iCount
    end

    return tiTypeCount
end

function fetch_inventory_count(tiItems)
    local iRetCount = 0

    for _, iCount in pairs(tiItems) do
        iRetCount = iRetCount + iCount
    end

    return iRetCount
end
