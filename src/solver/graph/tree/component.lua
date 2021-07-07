--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

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
    tpResourceNodes = {},
    tpResourceFields = {}
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

function CSolverTree:get_field_node(iMapid)
    return self.tpResourceNodes[iMapid]
end

function CSolverTree:get_field_nodes()
    return self.tpResourceNodes
end

function CSolverTree:_make_remissive_index_node_fields()
    local m_tpResourceNodes = self.tpResourceNodes
    local m_tpResourceFields = self.tpResourceFields

    for iMapid, pResource in pairs(m_tpResourceNodes) do
        local rgiResourceids = pResource:get_resources()
        for _, iResourceid in ipairs(rgiResourceids) do
            local rgiFields = create_inner_table_if_not_exists(m_tpResourceFields, iResourceid)
            table.insert(rgiFields, iMapid)
        end
    end
end

local function is_tree_leaf(pRscNode)
    return pRscNode._make_remissive_index_tree_resource_fields == nil
end

function CSolverTree:_make_remissive_index_tree_resource_fields()
    self:_make_remissive_index_node_fields()
    for _, pRegionRscTree in pairs(self:get_field_nodes()) do
        if not is_tree_leaf(pRegionRscTree) then
            pRegionRscTree:_make_remissive_index_tree_resource_fields()
        end
    end
end

function CSolverTree:make_remissive_index_resource_fields()
    self:_make_remissive_index_tree_resource_fields()
end

function CSolverTree:get_fields_from_resource(iResourceid)
    local m_tpResourceFields = self.tpResourceFields
    return m_tpResourceFields[iResourceid] or {}
end

function CSolverTree:debug_descriptor_region(iRegionid)
    local pRscTree = self

    log(LPath.PROCEDURES, "resources_quest.txt", "Regionid:", iRegionid)

    local iSrcMapid = pRscTree:get_field_source()
    local iDestMapid = pRscTree:get_field_destination()
    log(LPath.PROCEDURES, "resources_quest.txt", "Src: " .. iSrcMapid .. " Dest: " .. iDestMapid)

    local rgiRscs = pRscTree:get_resources()

    log(LPath.PROCEDURES, "resources_quest.txt", "Rscs:")
    local tpFieldRscs = pRscTree:get_field_nodes()
    for iMapid, pRsc in pairs(tpFieldRscs) do
        local st = ""
        for _, iRscid in pairs(pRsc:get_resources()) do
            local iRscType = math.floor(iRscid / 1000000000)
            local iRscUnit = iRscid % 1000000000

            st = st .. "{" .. iRscType .. ":" .. iRscUnit .. "}" .. ", "
        end

        log(LPath.PROCEDURES, "resources_quest.txt", "  " .. iMapid .. " : " .. st)
    end
    log(LPath.PROCEDURES, "resources_quest.txt", "---------")
end

function CSolverTree:debug_descriptor_tree()
    local pRscTree = self

    local iSrcMapid = pRscTree:get_field_source()
    local iDestMapid = pRscTree:get_field_destination()

    local tpFieldRscs = pRscTree:get_field_nodes()
    local rgiRscs = pRscTree:get_resources()

    log(LPath.PROCEDURES, "resources_quest.txt", "DEBUG TREE")
    for iRegionid, pRegionRscTree in pairs(tpFieldRscs) do
        log(LPath.PROCEDURES, "resources_quest.txt", "DEBUG REGION #" .. iRegionid)
        pRegionRscTree:debug_descriptor_region(iRegionid)
        log(LPath.PROCEDURES, "resources_quest.txt", "-----")
    end
    log(LPath.PROCEDURES, "resources_quest.txt", "=====")
end
