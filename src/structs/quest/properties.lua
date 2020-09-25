--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("utils.class")

CQuestProperties = createClass({
    iQuestid,
    bStart,
    pPropCheck,
    pPropAct
})

function CQuestProperties:get_quest_id()
    return self.iQuestid
end

function CQuestProperties:set_quest_id(iQuestid)
    self.iQuestid = iQuestid
end

function CQuestProperties:is_start()
    return self.bStart
end

function CQuestProperties:get_requirement()
    return self.pPropCheck
end

function CQuestProperties:set_requirement(pRequirement)
    self.pPropCheck = pRequirement
end

function CQuestProperties:get_action()
    return self.pPropAct
end

function CQuestProperties:set_action(pAction)
    self.pPropAct = pAction
end
