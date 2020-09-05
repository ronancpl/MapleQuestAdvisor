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

CUnitDataTable = createClass({
    tUnitFields = {}
})

function CUnitDataTable:add_entry(iSrcid)
    self.tUnitFields[iSrcid] = {}
end

function CUnitDataTable:add_location(iSrcid, iMapid)
    self.tUnitFields[iSrcid][iMapid] = 1
end

function CUnitDataTable:get_locations(iSrcid)
    return self.tUnitFields[iSrcid]
end
