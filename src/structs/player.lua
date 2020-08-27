--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("structs.storage.inventory");
require("utils.class");

CPlayer = createClass({
    siJob,
    siLevel,
    liExp,
    liExpAmass,
    iMapid,
    iMeso,
    siFame,
    ivtItems,
    ivtSkills,
    ivtQuests
})

function CPlayer:get_job()
    return self.siJob
end

function CPlayer:set_job(siJob)
    self.siJob = siJob
end

local function CPlayer:update_exp_amass() end

function CPlayer:get_level()
    return self.siLevel
end

function CPlayer:set_level(siLevel)
    self.siLevel = siLevel
    self:update_exp_amass()
end

function CPlayer:get_exp()
    return self.liExp
end

function CPlayer:set_exp(liExp)
    self.liExp = liExp
    CPlayer:update_exp_amass()
end

function CPlayer:add_exp(liExp)
    self.liExp += liExp
    CPlayer:update_exp_amass()
end

function CPlayer:get_mapid()
    return self.iMapid
end

function CPlayer:set_mapid(iMapid)
    self.iMapid = iMapid
end

function CPlayer:get_meso()
    return self.iMeso
end

function CPlayer:set_meso()
    self.iMeso = iMeso
end

function CPlayer:get_fame()
    return self.siFame
end

function CPlayer:set_fame(siFame)
    self.siFame = siFame
end

function CPlayer:get_items()
    return self.ivtItems
end

function CPlayer:get_skills()
    return self.ivtSkills
end

function CPlayer:get_quests()
    return self.ivtQuests
end
