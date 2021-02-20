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

CSolverQuestResource = createClass({
    tiMobs,
    tiItems,
    iFieldPlayer,
    tiFieldsEnter,
    iFieldNpc
})

function CSolverQuestResource:get_mobs()
    return self.tiMobs
end

function CSolverQuestResource:get_items()
    return self.tiItems
end

function CSolverQuestResource:get_field_current()
    return self.iFieldPlayer
end

function CSolverQuestResource:get_field_enter()
    return self.tiFieldsEnter
end

function CSolverQuestResource:get_field_npc()
    return self.iFieldNpc
end
