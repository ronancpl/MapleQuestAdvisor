--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("utils.struct.class")

CQuestResult = createClass({
    pRscTree,
    iReqExp,
    iReqMeso,
    iReqFame,
    bReqJob,
    tiReqSkills,
    tiReqMobs,
    tiReqQuests,
    tiReqItems,
    iAwdExp,
    iAwdMeso,
    iAwdFame,
    tiAwdSkills,
    tiAwdItems
})

function CQuestResult:get_resource_tree()
    return self.pRscTree
end

function CQuestResult:set_resource_tree(pRscTree)
    self.pRscTree = pRscTree
end

function CQuestResult:get_requisite_exp()
    return self.iReqExp
end

function CQuestResult:set_requisite_exp(iExp)
    self.iReqExp = iExp
end

function CQuestResult:get_requisite_meso()
    return self.iReqMeso
end

function CQuestResult:set_requisite_meso(iMeso)
    self.iReqMeso = iMeso
end

function CQuestResult:get_requisite_fame()
    return self.iReqFame
end

function CQuestResult:set_requisite_fame(iFame)
    self.iReqFame = iFame
end

function CQuestResult:has_requisite_job()
    return self.bReqJob
end

function CQuestResult:set_requisite_job(bAcceptedJob)
    self.bReqJob = bAcceptedJob
end

function CQuestResult:get_requisite_skills()
    return self.tiReqSkills
end

function CQuestResult:set_requisite_skills(tiSkills)
    self.tiReqSkills = tiSkills
end

function CQuestResult:get_requisite_mobs()
    return self.tiReqMobs
end

function CQuestResult:set_requisite_mobs(tiMobs)
    self.tiReqMobs = tiMobs
end

function CQuestResult:get_requisite_quests()
    return self.tiReqQuests
end

function CQuestResult:set_requisite_quests(tiQuests)
    self.tiReqQuests = tiQuests
end

function CQuestResult:get_requisite_items()
    return self.tiReqItems
end

function CQuestResult:set_requisite_items(tiItems)
    self.tiReqItems = tiItems
end

function CQuestResult:get_reward_exp()
    return self.iAwdExp
end

function CQuestResult:set_reward_exp(iExp)
    self.iAwdExp = iExp
end

function CQuestResult:get_reward_meso()
    return self.iAwdMeso
end

function CQuestResult:set_reward_meso(iMeso)
    self.iAwdMeso = iMeso
end

function CQuestResult:get_reward_fame()
    return self.iAwdFame
end

function CQuestResult:set_reward_fame(iFame)
    self.iAwdFame = iFame
end

function CQuestResult:get_reward_skills()
    return self.tiAwdSkills
end

function CQuestResult:set_reward_skills(tiSkills)
    self.tiAwdSkills = tiSkills
end

function CQuestResult:get_reward_items()
    return self.tiAwdItems
end

function CQuestResult:set_reward_items(tiItems)
    self.tiAwdItems = tiItems
end
