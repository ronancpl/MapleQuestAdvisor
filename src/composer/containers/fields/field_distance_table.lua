--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("router.filters.constant")
require("utils.procedure.unpack")
require("utils.struct.class")

CFieldDistanceTable = createClass({
    tFieldDistance = {}
})

function CFieldDistanceTable:add_field_entry(iSrcid)
    local m_tFieldDistance = self.tFieldDistance
    m_tFieldDistance[iSrcid] = {}
end

function CFieldDistanceTable:get_field_entries()
    return keys(self.tFieldDistance)
end

function CFieldDistanceTable:has_field_entry(iSrcid)
    local tFieldDists = self.tFieldDistance[iSrcid]
    return tFieldDists ~= nil
end

function CFieldDistanceTable:add_field_distance(iSrcid, iDestid, iDistance)
    local tFieldDists = self.tFieldDistance[iSrcid]     -- srcid entry already added
    tFieldDists[iDestid] = iDistance
end

function CFieldDistanceTable:remove_field_distance(iSrcid, iDestid)
    local tFieldDists = self.tFieldDistance[iSrcid]
    tFieldDists[iDestid] = nil
end

function CFieldDistanceTable:get_field_distances(iSrcid)
    local tFieldDists = self.tFieldDistance[iSrcid]
    return tFieldDists
end

function CFieldDistanceTable:_get_field_distance(iSrcid, iDestid)
    local tFieldDists = self.tFieldDistance[iSrcid]
    return tFieldDists[iDestid] or nil
end

function CFieldDistanceTable:get_field_distance(iSrcid, iDestid)
    return (self:has_field_entry(iSrcid) and self:_get_field_distance(iSrcid, iDestid)) or U_INT_MAX
end

function CFieldDistanceTable:debug_field_distance()
    print("FIELD DISTS:")

    for iSrcid, tFieldDists in pairs(self.tFieldDistance) do
        local st = "["
        for iDestid, iDist in pairs(tFieldDists) do
            st = st .. iDestid .. ":" .. iDist .. ", "
        end
        st = st .. "]"
        print(iSrcid .. " -> " .. st)
    end
    print("---------")
end
