--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("structs.quest.attributes.property")
require("structs.storage.inventory")
require("utils.class")

CQuestRequirement = createClass({CQuestProperty, {
    iNpcid = -1,
    pMapid = 10000,
    iMapidFieldEnter = -1,
    siLevelMin = -1,
    siLevelMax = -1,
    bJobAccess = false,
    bDateAccess = true,
    bRepeatable = false,
    bScripted = false
}})

function CQuestRequirement:get_npc()
    return self.iNpcid
end

function CQuestRequirement:set_npc(iNpcid)
    self.iNpcid = iNpcid
end

function CQuestRequirement:get_field(siRefMapid)
    local pMapid = self.pMapid
    if type(pMapid) == "table" then     -- this one is tricky: can be either a [number] or map of [continent, mapid]
        local iMapid = pMapid[get_continent_id(siRefMapid)]
        if iMapid == nil then
            for _, iRegionMapid in pairs(pMapid) do
                iMapid = iRegionMapid
                return iMapid
            end

            iMapid = -1
        end

        return iMapid
    end

    return self.pMapid
end

function CQuestRequirement:set_field(pMapid)
    self.pMapid = pMapid
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

function CQuestRequirement:set_date_access(sDateAccess)
    self.bDateAccess = string.len(sDateAccess) == 0
end

function CQuestRequirement:is_repeatable()
    return self.bRepeatable
end

function CQuestRequirement:set_repeatable(iRepeatable)
    self.bRepeatable = iRepeatable > 0
end

function CQuestRequirement:has_script()
    return self.bScript
end

function CQuestRequirement:set_script(sScript)
    self.bScript = string.len(sScript) > 0
end
