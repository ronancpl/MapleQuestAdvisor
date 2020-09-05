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

CPlayerDataTable = createClass({
    tExpTnl = {}
})

function CPlayerDataTable:add_exp_to_next_level(iExpNeeded)
    table.insert(self.tExpTnl, iExpNeeded)
end

function CPlayerDataTable:get_exp_to_next_level(iLevel)
    return self.tExpTnl[iLevel]
end
