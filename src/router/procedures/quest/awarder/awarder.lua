--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("router.procedures.quest.awarder.property")
require("utils.class")

CQuestAwarder = createClass({
    sName = "_NIL",
    fn_quest_property,
    fn_quest_rollback,
    fn_award_property
})

function CQuestAwarder:get_name()
    return self.sName
end

function CQuestAwarder:get_fn_quest_property()
    return self.fn_quest_property
end

function CQuestAwarder:get_fn_quest_rollback()
    return self.fn_quest_rollback
end

function CQuestAwarder:get_fn_award_property()
    return self.fn_award_property
end
