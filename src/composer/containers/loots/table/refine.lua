--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("composer.containers.loots.node.composition")
require("composer.containers.loots.node.refine")
require("utils.struct.class")

CRefineTable = createClass({
    tRefineItems = {},
    tRefineReferrers = {}
})

function CRefineTable:add_refine_entry(iItemidToCreate, rgpComposition)
    local tiCompositionNodes = {}

    for _, pComp in ipairs(rgpComposition) do
        local iItemid
        local iQty
        iItemid, iQty = unpack(pComp)

        local iCompQty = tiCompositionNodes[iItemid] or 0
        tiCompositionNodes[iItemid] = iCompQty + iQty
    end

    local pRefineEntry = CRefineEntry:new({iItemid = iItemidToCreate, tiComposition = tiCompositionNodes})
    self.tRefineItems[iItemidToCreate] = pRefineEntry
end

function CRefineTable:get_refine_entry(iItemidToCreate)
    return self.tRefineItems[iItemidToCreate]
end

function CRefineTable:make_remissive_index_item_referrer()
    local m_tRefineReferrers = self.tRefineReferrers
    local m_tRefineItems = self.tRefineItems

    for iItemidToCreate, pRefineEntry in pairs(m_tRefineItems) do
        for iItemid, _ in pairs(pRefineEntry:get_composition()) do
            local rgiRefs = m_tRefineReferrers[iItemid]
            if rgiRefs == nil then
                rgiRefs = {}
                m_tRefineReferrers[iItemid] = rgiRefs
            end

            table.insert(rgiRefs, iItemidToCreate)
        end
    end
end

function CRefineTable:get_item_referrers(iItemid)
    local m_tRefineReferrers = self.tRefineReferrers
    return m_tRefineReferrers[iItemid]
end
