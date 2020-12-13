--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("solver.graph.tree.resource")
require("utils.struct.class")

CSolverTree = createClass({CSolverResource, {
    iSrcMapid,
    iDestMapid,
    tpResourceNodes = {}
}})

function CSolverTree:get_field_source()
    return self.iSrcMapid
end

function CSolverTree:set_field_source(iMapid)
    self.iSrcMapid = iMapid
end

function CSolverTree:get_field_destination()
    return self.iDestMapid
end

function CSolverTree:set_field_destination(iMapid)
    self.iDestMapid = iMapid
end

function CSolverTree:add_field_node(iMapid, pResource)
    self.tpResourceNodes[iMapid] = pResource
end

function CSolverTree:get_field_nodes()
    return self.tpResourceNodes
end
