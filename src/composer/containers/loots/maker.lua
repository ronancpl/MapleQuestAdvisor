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

CMakerTable = createClass({
    tCreateItems = {}
})

function CMakerTable:add_maker_create_item(iSrcid)
    self.tCreateItems[iSrcid] = 1
end

function CMakerTable:is_maker_create_item(iSrcid)
    return self.tCreateItems[iSrcid] ~= nil
end
