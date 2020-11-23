--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("utils.struct.class")

CQuestProperties = createClass({
    iQuestid,
    bStart,
    pPropCheck,
    pPropAct,
    bActive,
    rgfn_active_check_unit,
    rgfn_active_check_invt,
    rgfn_active_act_unit,
    rgfn_active_act_invt
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
    self.rgfn_active_check_unit, self.rgfn_active_check_invt = pRequirement:fetch_active_elements(rgfn_get)
    pRequirement:set_default_on_empty_requirements()
end

function CQuestProperties:get_action()
    return self.pPropAct
end

function CQuestProperties:set_action(pAction, rgfn_get)
    self.pPropAct = pAction
    self.rgfn_active_act_unit, self.rgfn_active_act_invt = pAction:fetch_active_elements(rgfn_get)
    pAction:set_default_on_empty_actions()
end

function CQuestProperties:is_active_on_grid()
    return self.bActive
end

function CQuestProperties:set_active_on_grid(bActive)
    return self.bActive = bActive
end

function CQuestProperties:get_rgfn_active_requirements()
    return self.rgfn_active_check_unit, self.rgfn_active_check_invt, self.pPropCheck
end

function CQuestProperties:get_rgfn_active_awards()
    return self.rgfn_active_act_unit, self.rgfn_active_act_invt, self.pPropAct
end

local function fn_value_start_property(pQuestProp)
    return pQuestProp:is_start() and 0 or 1
end

function CQuestProperties:compare(pOtherProp)
    local iQuestidDiff = self:get_quest_id() - pOtherProp:get_quest_id()
    local iStartDiff = fn_value_start_property(self) - fn_value_start_property(pOtherProp)

    return 2 * iQuestidDiff + iStartDiff
end
