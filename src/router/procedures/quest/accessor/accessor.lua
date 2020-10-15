--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("router.procedures.quest.accessor.property")
require("structs.quest.attributes.property")
require("structs.quest.attributes.requirement")
require("utils.struct.class")

CQuestAccessor = createClass({
    sName = "_NIL",
    fn_get_property,
    fn_get_player_property,
    fn_diff_pending_property,
    fn_diff_pending_type
})

function CQuestAccessor:get_name()
    return self.sName
end

function CQuestAccessor:get_fn_property()
    return self.fn_get_property
end

function CQuestAccessor:get_fn_player_property()
    return self.fn_get_player_property
end

function CQuestAccessor:get_fn_pending_property()
    return self.fn_diff_pending_property
end

function CQuestAccessor:get_fn_pending_progress()
    return self.fn_diff_pending_type
end
