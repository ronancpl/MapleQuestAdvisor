--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("router.filters.constant")
require("utils.procedure.unpack")
require("utils.struct.class")

CRetrieveItemTable = createClass({
    tpRegionAreaLoots = {},
    tpRegionLootChances = {}
})

function CRetrieveItemTable:_add_loot_field_to_table_acquisition_loot(ctFieldsLandscape, ctFieldsMeta, iSrcid, iMapid, pLoot)
    local iRegionid = ctFieldsLandscape:get_region_by_mapid(iMapid)
    local iFieldReturn = ctFieldsMeta:get_field_return(iMapid) or iMapid

    local m_tpRegionAreaLoots = self.tpRegionAreaLoots
    local tAreaLoot = create_inner_table_if_not_exists(m_tpRegionAreaLoots, iRegionid)
    tAreaLoot = create_inner_table_if_not_exists(tAreaLoot, iFieldReturn)

    table.insert(tAreaLoot, pLoot)
end

function CRetrieveItemTable:add_acquisition_loot(ctFieldsLandscape, ctFieldsMeta, ctLootSources, pLoot)
    local iSrcid = pLoot:get_sourceid()

    local rgiMapids = ctLootSources:get_locations(iSrcid)
    for _, iMapid in ipairs(rgiMapids) do
        self:_add_loot_field_to_table_acquisition_loot(ctFieldsLandscape, ctFieldsMeta, iSrcid, iMapid, pLoot)
    end
end

local function calc_loot_chance(pLoot, iDropRate)
    local fChance = pLoot:get_chance() * iDropRate
    return fChance
end

function CRetrieveItemTable:_calc_region_loot_chance(trgpAreaLoots, iDropRate)
    local fRegionLootChance = 0.0
    local iTotalLoots = 0

    local tpFieldAreaChances = {}
    for iRetMapid, rgpLoots in pairs(trgpAreaLoots) do
        local nLoots = #rgpLoots

        local fAvgChance = 0.0
        for _, pLoot in ipairs(rgpLoots) do
            fAvgChance = fAvgChance + calc_loot_chance(pLoot, iDropRate)
        end
        fAvgChance = fAvgChance / nLoots
        fAvgChance = math.clamp(fAvgChance, 0.0, 1.0)

        iTotalLoots = iTotalLoots + nLoots

        tpFieldAreaChances[iRetMapid] = {fAvgChance, nLoots}
    end

    -- weighted avg of area loot chances
    local fRegionChance = 0.0
    for iRetMapid, pChanceCount in pairs(tpFieldAreaChances) do
        local fAreaChance
        local nAreaLoots
        fAreaChance, nAreaLoots = unpack(pChanceCount)

        fRegionChance = fRegionChance + (fAreaChance * (nAreaLoots / iTotalLoots))
    end

    return fRegionChance
end

local function split_area_loots_by_item(tpRegionAreaLoots)
    local tpAreaItemLoots = {}

    for iRetMapid, rgpLoots in pairs(tpRegionAreaLoots) do
        for _, pLoot in pairs(rgpLoots) do
            local iRscid = pLoot:get_itemid()

            local trgpItemAreaLoots = create_inner_table_if_not_exists(tpAreaItemLoots, iRscid)
            local rgpLoots = create_inner_table_if_not_exists(trgpItemAreaLoots, iRetMapid)

            table.insert(rgpLoots, pLoot)
        end
    end

    return tpAreaItemLoots
end

function CRetrieveItemTable:build_acquisition_loot_chances(iDropRate)
    local m_tpRegionLootChances = self.tpRegionLootChances
    clear_table(m_tpRegionLootChances)

    local m_tpRegionAreaLoots = self.tpRegionAreaLoots
    for iRegionid, tpRegionAreaLoots in pairs(m_tpRegionAreaLoots) do
        local tpAreaItemLoots = split_area_loots_by_item(tpRegionAreaLoots)
        for iRscid, trgpAreaLoots in pairs(tpAreaItemLoots) do
            local tfItemAreaChances = create_inner_table_if_not_exists(m_tpRegionLootChances, iRegionid)
            tfItemAreaChances[iRscid] = self:_calc_region_loot_chance(trgpAreaLoots, iDropRate)
        end
    end
end

function CRetrieveItemTable:_get_acquisition_chance_overall(iLootSrc)
    local fLootChance = 0.0
    local iLootRegions = 0

    local m_tpRegionLootChances = self.tpRegionLootChances
    for _, tfLootAreaChances in pairs(m_tpRegionLootChances) do
        fLootAreaChance = tfLootAreaChances[iLootSrc]
        if fLootAreaChance ~= nil then
            fLootChance = fLootChance + fLootAreaChance
            iLootRegions = iLootRegions + 1
        end
    end

    local fAvgLootChance
    if iLootRegions > 0 then
        fAvgLootChance = fLootChance / iLootRegions
    else
        fAvgLootChance = 0.0
    end

    return fAvgLootChance
end

function CRetrieveItemTable:_get_acquisition_chance_by_region(iLootSrc, iRegionid)
    local fLootChance = nil

    local m_tpRegionLootChances = self.tpRegionLootChances
    local tfLootAreaChances = m_tpRegionLootChances[iRegionid]
    if tfLootAreaChances ~= nil then
        fLootChance = tfLootAreaChances[iLootSrc]
    end

    return fLootChance
end

function CRetrieveItemTable:get_acquisition_chance(iLootSrc, iRegionid)
    local fChance
    if iRegionid then
        fChance = self:_get_acquisition_chance_by_region(iLootSrc, iRegionid)
    end

    if not fChance then
        fChance = self:_get_acquisition_chance_overall(iLootSrc)
    end

    return fChance
end
