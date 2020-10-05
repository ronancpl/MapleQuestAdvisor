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
    pPropAct,
    rgfn_active_check,
    rgfn_active_act,
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

function CQuestProperties:set_requirement(pRequirement, rgfn_get)
    self.pPropCheck = pRequirement
    self.rgfn_active_check = pRequirement:fetch_active_elements(rgfn_get)
    pRequirement:set_default_on_empty_requirements()
end

function CQuestProperties:get_action()
    return self.pPropAct
end

function CQuestProperties:set_action(pAction, rgfn_get)
    self.pPropAct = pAction
    self.rgfn_active_act = pAction:fetch_active_elements(rgfn_get)
    pAction:set_default_on_empty_actions()
end

function CQuestProperties:get_rgfn_active_requirements()
    return self.rgfn_active_check, self.pPropCheck
end

function CQuestProperties:get_rgfn_active_awards()
    return self.rgfn_active_act, self.pPropAct
end
