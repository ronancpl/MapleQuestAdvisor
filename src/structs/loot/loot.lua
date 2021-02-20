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

CLoot = createClass({
    iItemid = -1,
    iSourceid = -1,
    fChance = 0.0,
    siMinItems = 0,
    siMaxItems = 0
})

function CLoot:get_itemid()
    return self.iItemid
end

function CLoot:set_itemid(iItemid)
    self.iItemid = iItemid
end

function CLoot:get_sourceid()
    return self.iSourceid
end

function CLoot:set_sourceid(iSourceid)
    self.iSourceid = iSourceid
end

function CLoot:get_chance()
    return self.fChance
end

function CLoot:set_chance(fChance)
    self.fChance = fChance
end

function CLoot:get_min_items()
    return self.siMinItems
end

function CLoot:set_min_items(siMinItems)
    self.siMinItems = siMinItems
end

function CLoot:get_max_items()
    return self.siMaxItems
end

function CLoot:set_max_items(siMaxItems)
    self.siMaxItems = siMaxItems
end
