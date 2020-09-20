--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("structs.storage.inventory")
require("utils.class")

CQuestProperty = createClass({
    iExp = 0,
    iMeso = 0,
    siFame = 0,
    ivtSkills = CInventory:new(),
    ivtItems = CInventory:new(),
    ivtMobs = CInventory:new(),
    ivtQuests = CInventory:new()
})

function CQuestProperty:get_exp()
    return self.iExp
end

function CQuestProperty:set_exp(iExp)
    self.iExp = iExp
end

function CQuestProperty:get_meso()
    return self.iMeso
end

function CQuestProperty:set_meso(iMeso)
    self.iMeso = iMeso
end

function CQuestProperty:get_fame()
    return self.siFame
end

function CQuestProperty:set_fame(siFame)
    self.siFame = siFame
end

function CQuestProperty:get_skills()
    return self.ivtSkills
end

function CQuestProperty:add_skill(iId)
    return self.ivtSkills:add_item(iId, 1)
end

function CQuestProperty:get_items()
    return self.ivtItems
end

function CQuestProperty:add_item(iId, iCount)
    self.ivtItems:add_item(iId, iCount)
end

function CQuestProperty:get_mobs()
    return self.ivtMobs
end

function CQuestProperty:add_mob(iId, iCount)
    self.ivtMobs:add_item(iId, iCount)
end

function CQuestProperty:get_quests()
    return self.ivtQuests
end

function CQuestProperty:add_quest(iId, iState)
    self.ivtQuests:add_item(iId, iState)
end
