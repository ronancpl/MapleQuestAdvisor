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

CQuestProperties = createClass({
    iQuestid,
    bStart,
    iNextQuestid,
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

function CQuestProperties:get_status()
    return self:is_start() and "S" or "E"
end

function CQuestProperties:get_title()
    local pQuest = ctQuests:get_quest_by_id(self:get_quest_id())
    return pQuest:get_title() .. " (" .. self:get_status() .. ")"
end

function CQuestProperties:get_name(bPrependStart)
    local sId = tostring(self:get_quest_id())
    local sStart = self:is_start() and "S" or "E"

    if bPrependStart then
        return sStart .. sId
    else
        return sId .. sStart
    end
end

function CQuestProperties:get_next_quest_id()
    return self.iNextQuestid
end

function CQuestProperties:set_next_quest_id(iQuestid)
    self.iNextQuestid = iQuestid
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
    self.bActive = bActive
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

function CQuestProperties:install_player_state(pPlayerState)
    self.pPropCheck:install_player_state(pPlayerState)
    self.pPropAct:install_player_state(pPlayerState)
end

function CQuestProperties:extract_player_state()
    self.pPropCheck:extract_player_state()
    self.pPropAct:extract_player_state()
end
