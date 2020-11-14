--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("utils.procedure.unpack")
require("utils.struct.class")

local U_INT_MAX = 0x7FFFFFFF

CFieldDistanceTable = createClass({
    tFieldDistance = {}
})

function CFieldDistanceTable:add_field_entry(iSrcid)
    self.tFieldDistance[iSrcid] = {}
end

function CFieldDistanceTable:get_field_entries()
    return unpack_keys(self.tFieldDistance)
end

function CFieldDistanceTable:add_field_distance(iSrcid, iDestId, iDistance)
    self.tFieldDistance[iSrcid][iDestId] = iDistance     -- srcid entry already added
end

function CFieldDistanceTable:get_field_distances(iSrcid)
    return self.tFieldDistance[iSrcid]
end

function CFieldDistanceTable:get_field_distance(iSrcid, iDestid)
    return self.tFieldDistance[iSrcid][iDestid] or U_INT_MAX
end
