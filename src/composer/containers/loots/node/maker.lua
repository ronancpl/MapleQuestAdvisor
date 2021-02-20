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

CMakerNode = createClass({
    iSrcid,
    iReqid,
    iReqQty
})

function CMakerNode:get_itemid()
    return self.iSrcid
end

function CMakerNode:get_requirement_id()
    return self.iReqid
end

function CMakerNode:get_requirement_quantity()
    return self.iReqQty
end
