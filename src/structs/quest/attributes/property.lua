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
require("utils.procedure.string")
require("utils.struct.array")
require("utils.struct.class")

CQuestProperty = createClass({
    iExp,
    iMeso,
    siFame,
    ivtSkills = CInventory:new(),
    ivtItems = CInventory:new(),
    ivtMobs = CInventory:new(),
    ivtQuests = CInventory:new(),
    rgpJobs = SArray:new()          -- not only requirement, really?
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

function CQuestProperty:get_jobs()
    return self.rgpJobs
end

function CQuestProperty:set_jobs(rgpQuestJobs)
    local m_rgpJobs = self.rgpJobs

    m_rgpJobs:remove_all()
    m_rgpJobs:add_all(rgpQuestJobs)

    m_rgpJobs:sort()
end

function CQuestProperty:_is_active_element(fn_get)
    local pRes = fn_get(self)

    if type(pRes) ~= "table" then
        return pRes ~= nil, false
    else
        return pRes:size() > 0, true  -- inventory-type
    end
end

function CQuestProperty:fetch_active_elements(rgfn_get)
    local rgfn_active_units = {}
    local rgfn_active_invts = {}

    for _, fn_get in ipairs(rgfn_get) do
        local bActive
        local bInvt

        bActive, bInvt = self:_is_active_element(fn_get)
        if bActive then
            if bInvt then
                table.insert(rgfn_active_invts, fn_get)
            else
                table.insert(rgfn_active_units, fn_get)
            end
        end
    end

    return rgfn_active_units, rgfn_active_invts
end

function CQuestProperty:_set_default_on_nil(sKey, pDef)
    if self[sKey] == nil then
        self[sKey] = pDef
    end
end

function CQuestProperty:_set_default_on_empty_properties(tsDef)
    for sKey, pDef in pairs(tsDef) do
        self:_set_default_on_nil(sKey, pDef)
    end
end

function CQuestProperty:set_default_on_empty_properties()
    local tsDef = {iExp = 0, iMeso = 0, siFame = 0}
    self:_set_default_on_empty_properties(tsDef)
end

function fetch_property_get_methods(CPropertyType)
    local pReq = CPropertyType:new()

    local rgGets = {"get_", "is_", "has_"}
    local rgfn_get = {}

    for sName, pMember in pairs(getClassMethods(pReq)) do
        for _, sGetMatch in ipairs(rgGets) do
            if string.starts_with(sName, sGetMatch) then
                table.insert(rgfn_get, pMember)
                break
            end
        end
    end

    return rgfn_get
end
