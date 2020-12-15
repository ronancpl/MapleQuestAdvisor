--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("structs.loot.loot")
require("utils.struct.class")

CLootTable = createClass({
    tMobItems = {},
    tReactorItems = {}
})

local tfn_chance_ratio = {
    ["mob"] = function (x) return x / 999999 end,
    ["reactor"] = function (x) return 1 / x end
}

local function get_chance_by_type(iChance, sTypeLoot)
    return tfn_chance_ratio[sTypeLoot](iChance)
end

local function create_loot(iItemid, iChance, sLootType, siMinItems, siMaxItems)
    local fChance = get_chance_by_type(iChance, sLootType)

    local pLoot = CLoot:new()
    pLoot:set_sourceid(iItemid)
    pLoot:set_chance(fChance)
    pLoot:set_min_items(siMinItems)
    pLoot:set_max_items(siMaxItems)

    return pLoot
end

local function insert_loot(tItems, pLoot)
    local iSrcid = pLoot:get_sourceid()
    local rgpLoots = tItems[iSrcid]

    if rgpLoots == nil then
        rgpLoots = {}
        tItems[iSrcid] = rgpLoots
    end

    table.insert(rgpLoots, pLoot)
end

local function take_relevant_avg_loots(rgpLoots, nLoots)
    local fChance = 0.0
    local iMinItems = 0
    local iMaxItems = 0

    local iRelevantIdx = -1
    local fRelevantChance = -1.0
    for iIdx, pLoot in ipairs(rgpLoots) do
        local fLootChance = pLoot:get_chance()
        if fRelevantChance < fLootChance then
            fRelevantChance = fLootChance
            iRelevantIdx = iIdx
        end

        -- 1 representative loot, take arithmetic avg of loots
        fChance = fChance + fLootChance
        iMinItems = iMinItems + pLoot:get_min_items()
        iMaxItems = iMaxItems + pLoot:get_max_items()
    end

    fChance = fChance / nLoots
    iMinItems = math.ceil(iMinItems / nLoots)
    iMaxItems = math.ceil(iMaxItems / nLoots)

    return fChance, iMinItems, iMaxItems, iRelevantIdx
end

local function apply_representative_loot(pSquashed, pRlvItem, fAvgChance, siAvgMinItems, siAvgMaxItems)
    -- apply stdev-upper into representative loot values

    local fRlvChance = pRlvItem:get_chance()
    local iRlvMinItems = pRlvItem:get_min_items()
    local iRlvMaxItems = pRlvItem:get_max_items()

    local fDiffChance = math.abs(fRlvChance - fAvgChance)
    local iDiffMinItems = math.abs(iRlvMinItems - siAvgMinItems)
    local iDiffMaxItems = math.abs(iRlvMaxItems - siAvgMaxItems)

    pSquashed:set_chance(fAvgChance + math.sqrt(fDiffChance))
    pSquashed:set_min_items(math.ceil(siAvgMinItems + math.sqrt(iDiffMinItems)))
    pSquashed:set_max_items(math.ceil(siAvgMaxItems + math.sqrt(iDiffMaxItems)))
end

local function squash_entry_loots(iItemid, rgpLoots)
    local pSquashed = create_loot(iItemid, 0, "mob", 0, 0)

    local nLoots = #rgpLoots
    if nLoots > 0 then
        local fAvgChance
        local siAvgMinItems
        local siAvgMaxItems
        local iRelevantIdx

        fAvgChance, siAvgMinItems, siAvgMaxItems, iRelevantIdx = take_relevant_avg_loots(rgpLoots, nLoots)
        local pRlvItem = rgpLoots[iRelevantIdx]
        apply_representative_loot(pSquashed, pRlvItem, fAvgChance, siAvgMinItems, siAvgMaxItems)
    end

    return pSquashed
end

function CLootTable:add_mob_entry(iSrcid)
    self.tMobItems[iSrcid] = {}
end

function CLootTable:add_mob_loot(iSrcid, iItemid, iChance, siMinItems, siMaxItems)
    local pLoot = create_loot(iItemid, iChance, "mob", siMinItems, siMaxItems)
    insert_loot(self.tMobItems, pLoot)
end

function CLootTable:get_mob_entry(iSrcid)
    return self.tMobItems[iSrcid]
end

function CLootTable:get_mob_entries()
    return self.tMobItems
end

function CLootTable:add_reactor_loot(iSrcid, iItemid, iChance, siMinItems, siMaxItems)
    local pLoot = create_loot(iItemid, iChance, "reactor", siMinItems, siMaxItems)
    insert_loot(self.tReactorItems, pLoot)
end

function CLootTable:get_reactor_entry(iSrcid)
    return self.tReactorItems[iSrcid]
end

function CLootTable:get_reactor_entries()
    return self.tReactorItems
end

local function squash_type_loots(tItems)
    local tEntries = {}

    for iSrcid, rgpLoots in pairs(tItems) do
        local tItemEntries = {}
        tEntries[iSrcid] = tItemEntries

        for _, pLoot in ipairs(rgpLoots) do
            local iRscid = pLoot:get_sourceid()

            local rgpRscLoots = tItemEntries[iRscid]
            if rgpRscLoots == nil then
                rgpRscLoots = {}
                tItemEntries[iRscid] = rgpRscLoots
            end

            table.insert(rgpRscLoots, pLoot)
        end
    end

    for iSrcid, tItemEntries in pairs(tEntries) do
        local tRscItems = {}
        tItems[iSrcid] = tRscItems

        for iRscid, rgpRscLoots in pairs(tItemEntries) do
            tRscItems[iRscid] = squash_entry_loots(iRscid, rgpRscLoots)
        end
    end
end

function CLootTable:squash_loots()
    -- after inserting all loots, unify loots into one representative for each srcid

    squash_type_loots(self.tMobItems)
    squash_type_loots(self.tReactorItems)
end
