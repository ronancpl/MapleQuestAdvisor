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
require("structs.quest.attributes.category.job")
require("structs.quest.attributes.property")
require("utils.struct.class")

CQuestRequirement = createClass({CQuestProperty, {
    iNpcid,
    pMapid,
    siLevelMin,
    siLevelMax,
    bJobAccess,
    bDateAccess,
    bRepeatable,
    bScripted
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

local function fn_compare_job(siJobid, siPlayerJobid)
    return siJobid - siPlayerJobid
end

function CQuestRequirement:_in_job_tree(siPlayerJob)
    local m_rgpJobs = self.rgpJobs

    local bRet
    if m_rgpJobs:size() > 0 then
        local iIdx = m_rgpJobs:bsearch(fn_compare_job, siPlayerJob, true, true)
        if iIdx >= 1 and iIdx <= m_rgpJobs:size() then
            bRet = is_in_job_tree(m_rgpJobs:get(iIdx), siPlayerJob)
        else
            bRet = false
        end
    else
        bRet = true
    end

    return bRet
end

function CQuestRequirement:set_job_access(siPlayerJob)   -- requires runtime update, to allow boolean checks
    self.bJobAccess = self:_in_job_tree(siPlayerJob) and 1 or 0     -- numeric booleans, for compare
end

function CQuestRequirement:has_date_access()
    return self.bDateAccess
end

function CQuestRequirement:set_date_access(sDateAccess)
    self.bDateAccess = string.len(sDateAccess) == 0 and 1 or 0
end

function CQuestRequirement:is_repeatable()
    return self.bRepeatable
end

function CQuestRequirement:set_repeatable(iRepeatable)
    self.bRepeatable = iRepeatable > 0 and 1 or 0
end

function CQuestRequirement:has_script()
    return self.bScript
end

function CQuestRequirement:set_script(sScript)
    self.bScript = string.len(sScript) > 0 and 1 or 0
end

function CQuestRequirement:set_default_on_empty_requirements()
    self:set_default_on_empty_properties()  -- calls super-method

    local tsDef = {iNpcid = -1, pMapid = 10000, ivtFieldsEnter = CInventory:new(), siLevelMin = -1, siLevelMax = -1, bJobAccess = false, rgpJobs = SArray:new(), bDateAccess = true, bRepeatable = false, bScripted = false}
    self:_set_default_on_empty_properties(tsDef)
end
