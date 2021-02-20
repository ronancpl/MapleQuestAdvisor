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

function CQuestResult:set_resource_tree(pRscTree)
    self.pRscTree = pRscTree
end

function CQuestResult:set_requisite_exp(iExp)
    self.iReqExp = iExp
end

function CQuestResult:set_requisite_meso(iMeso)
    self.iReqMeso = iMeso
end

function CQuestResult:set_requisite_fame(iFame)
    self.iReqFame = iFame
end

function CQuestResult:has_requisite_job(bAcceptedJob)
    self.bReqJob = bAcceptedJob
end

function CQuestResult:set_requisite_skills(tiSkills)
    self.tiReqSkills = tiSkills
end

function CQuestResult:set_requisite_mobs(tiMobs)
    self.tiReqMobs = tiMobs
end

function CQuestResult:set_requisite_quests(tiQuests)
    self.tiReqQuests = tiQuests
end

function CQuestResult:set_requisite_items(tiItems)
    self.tiReqItems = tiItems
end

function CQuestResult:set_reward_exp(iExp)
    self.iAwdExp = iExp
end

function CQuestResult:set_reward_meso(iMeso)
    self.iAwdMeso = iMeso
end

function CQuestResult:set_reward_fame(iFame)
    self.iAwdFame = iFame
end

function CQuestResult:set_reward_skills(tiSkills)
    self.tiAwdSkills = tiSkills
end

function CQuestResult:set_reward_items(tiItems)
    self.tiAwdItems = tiItems
end
