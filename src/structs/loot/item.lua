--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("utils.struct.array")
require("utils.struct.class")

CItem = createClass({
    iItemid = -1,
    trgLootMobs = {},
    trgLootReactors = {}
})

function CItem:get_itemid()
    return self.iItemid
end

function CItem:set_itemid(iItemid)
    self.iItemid = iItemid
end

function CItem:_add_loot(trgLoot, pLoot)
    local iItemid = pLoot:get_itemid()

    local rgIdLoot = trgLoot[iItemid]
    if rgIdLoot == nil then
        rgIdLoot = SArray:new()
        trgLoot[iItemid] = rgIdLoot
    end

    rgIdLoot:add(pLoot)
end

function CItem:get_loot_mobs()
    return self.trgLootMobs
end

function CItem:add_loot_mob(pLoot)
    self:_add_loot(self.trgLootMobs, pLoot)
end

function CItem:get_loot_reactors()
    return self.trgLootReactors
end

function CItem:add_loot_reactor(pLoot)
    self:_add_loot(self.trgLootReactors, pLoot)
end
