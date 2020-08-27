--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("utils.class");

CQuestProperties = createClass({
    rgpChecks = {},
    rgpActs = {}
})

function CQuestProperties:get_requirements()
    return self.rgpChecks
end

function CQuestProperties:add_requirement(pRequirement)
    table.insert(self.rgpChecks, pRequirement)
end

function CQuestProperties:get_actions()
    return self.rgpActs
end

function CQuestProperties:add_action(pAction)
    table.insert(self.rgpActs, pAction)
end
