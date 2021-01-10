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

function CSolverTree:debug_descriptor_region(iRegionid)
    local pRscTree = self

    print("Regionid:", iRegionid)

    local iSrcMapid = pRscTree:get_field_source()
    local iDestMapid = pRscTree:get_field_destination()
    print("Src: " .. iSrcMapid .. " Dest: " .. iDestMapid)

    local rgiRscs = pRscTree:get_resources()

    print("Rscs:")
    local tpFieldRscs = pRscTree:get_field_nodes()
    for iMapid, pRsc in pairs(tpFieldRscs) do
        local st = ""
        for _, iRscid in pairs(pRsc:get_resources()) do
            local iRscType = math.floor(iRscid / 1000000000)
            local iRscUnit = iRscid % 1000000000

            st = st .. "{" .. iRscType .. ":" .. iRscUnit .. "}" .. ", "
        end

        print("  " .. iMapid .. " : " .. st)
    end
    print("---------")
end

function CSolverTree:debug_descriptor_tree()
    local pRscTree = self

    local iSrcMapid = pRscTree:get_field_source()
    local iDestMapid = pRscTree:get_field_destination()

    local tpFieldRscs = pRscTree:get_field_nodes()
    local rgiRscs = pRscTree:get_resources()

    print("DEBUG TREE")
    for iRegionid, pRegionRscTree in pairs(tpFieldRscs) do
        print("DEBUG REGION #" .. iRegionid)
        pRegionRscTree:debug_descriptor_region(iRegionid)
        print("-----")
    end
    print("=====")
end
