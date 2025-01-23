--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

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

function CRefineTable:add_refine_entry(iItemidToCreate, iCountToCreate, rgpComposition)
    local tiCompositionNodes = {}

    for _, pComp in ipairs(rgpComposition) do
        local iItemid
        local iQty
        iQty, iItemid = unpack(pComp)

        local iCompQty = tiCompositionNodes[iItemid] or 0
        tiCompositionNodes[iItemid] = iCompQty + iQty
    end

    local pRefineEntry = CRefineEntry:new({iItemid = iItemidToCreate, tiComposition = tiCompositionNodes})
    self.tRefineItems[iItemidToCreate] = {iCountToCreate, pRefineEntry}
end

function CRefineTable:get_refine_entry(iItemidToCreate)
    if self.tRefineItems[iItemidToCreate] == nil then return nil, nil end
    return self.tRefineItems[iItemidToCreate][1], self.tRefineItems[iItemidToCreate][2]
end

function CRefineTable:make_remissive_index_item_referrer()
    local m_tRefineReferrers = self.tRefineReferrers
    local m_tRefineItems = self.tRefineItems

    for iItemidToCreate, pRefine in pairs(m_tRefineItems) do
        local pRefineEntry = pRefine[2]

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

function CRefineTable:debug_refines()
    local m_tRefineReferrers = self.tRefineReferrers
    local m_tRefineItems = self.tRefineItems

    print(" ------ Refine table ------ ")
    for iItemid, pRefine in pairs(m_tRefineItems) do
        local iCount = pRefine[1]
        local pRefineEntry = pRefine[2]

        local st = ""
        for iItemid, iCount in pairs(pRefineEntry:get_composition()) do
            st = st .. tostring(iItemid) .. ":" .. tostring(iCount) .. ", "
        end
        print(tostring(iItemid) .. "x" .. tostring(iCount) .. " == [" .. st .. "]")
    end

    print(" ---- Refine referrers ---- ")
    for iItemid, rgiRefs in pairs(m_tRefineReferrers) do
        local st = ""
        for _, iRef in pairs(rgiRefs) do
            st = st .. tostring(iRef) .. ", "
        end
        print(tostring(iItemid) .. " == [" .. st .. "]")
    end

    os.execute("pause")
end
