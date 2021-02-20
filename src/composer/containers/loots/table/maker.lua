--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("composer.containers.loots.node.maker")
require("utils.struct.class")

CMakerTable = createClass({
    tCreateItems = {}
})

function CMakerTable:add_maker_create_item(iSrcid, iReqid, iReqQty)
    local pMakerEntry = CMakerNode:new({iSrcid = iSrcid, iReqid = iReqid, iReqQty = iReqQty})
    self.tCreateItems[iSrcid] = pMakerEntry
end

function CMakerTable:get_maker_requirement(iSrcid)
    local pMakerEntry = self.tCreateItems[iSrcid]

    if pMakerEntry ~= nil then
        return pMakerEntry:get_requirement_id(), pMakerEntry:get_requirement_quantity()
    else
        return nil
    end
end
