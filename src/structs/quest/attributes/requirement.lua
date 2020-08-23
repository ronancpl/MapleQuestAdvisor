--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("utils/class");
require("structs/quest/attributes/property");
require("structs/storage/inventory");

CQuestRequirement = createClass(CQuestProperty, {
    iNpcid = -1,
    iMapid = 10000,
    iMapidFieldEnter = -1,
    siLevelMin = -1,
    siLevelMax = -1,
    bJobAccess = false,
    bDateAccess = true,
    bRepeatable = false,
    ivtQuests = CInventory:new()
})

function CQuestRequirement:get_npc()
    return self.iMapid
end

function CQuestRequirement:set_npc(iNpcid)
    self.iNpcid = iNpcid
end

function CQuestRequirement:get_field()
    return self.iMapid
end

function CQuestRequirement:set_field(iMapid)
    self.iMapid = iMapid
end

function CQuestRequirement:get_field_enter()
    return self.iMapidFieldEnter
end

function CQuestRequirement:set_field_enter(iMapidFieldEnter)
    self.iMapidFieldEnter = iMapidFieldEnter
end

function CQuestRequirement:get_level_min()
    return self.siLevelMin
end

function CQuestRequirement:set_level_min(siLevelMin)
    self.siLevelMin = siLevelMin
end

function CQuestRequirement:get_level_max()
    return self.siLevelMax
end

function CQuestRequirement:set_level_max(siLevelMax)
    self.siLevelMax = siLevelMax
end

function CQuestRequirement:has_job_access()
    return self.bJobAccess
end

function CQuestRequirement:set_job_access(bJobAccess)   -- requires runtime update, boolean check
    self.bJobAccess = bJobAccess
end

function CQuestRequirement:has_date_access()
    return self.bDateAccess
end

function CQuestRequirement:set_date_access(iDateAccess)
    self.bDateAccess = iDateAccess > 0
end

function CQuestRequirement:is_repeatable()
    return self.bRepeatable
end

function CQuestRequirement:set_repeatable(iRepeatable)
    self.bRepeatable = iRepeatable > 0
end

function CQuestRequirement:get_quests()
    return self.ivtQuests
end

function CQuestRequirement:add_quest(iId)
    self.ivtQuests:add_item(iId, 1)
end
