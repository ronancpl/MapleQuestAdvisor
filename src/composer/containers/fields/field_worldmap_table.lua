--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("utils.procedure.sort")
require("utils.struct.class")

CFieldWorldmapTable = createClass({
    tpWmapRegions = {},
    tiAreaWmapId = {}
})

function CFieldWorldmapTable:add_region_entry(sName, pWmapRegion)
    local m_tpWmapRegions = self.tpWmapRegions
    m_tpWmapRegions[sName] = pWmapRegion
end

function CFieldWorldmapTable:get_region_entry(sName)
    local m_tpWmapRegions = self.tpWmapRegions
    return m_tpWmapRegions[sName]
end

function CFieldWorldmapTable:get_region_entries()
    local m_tpWmapRegions = self.tpWmapRegions

    local rgsWmapNames = keys(m_tpWmapRegions)
    return rgsWmapNames
end

function CFieldWorldmapTable:get_worldmap_id(sWmapName)
    return tonumber(sWmapName:sub(9, 11))
end

function CFieldWorldmapTable:make_remissive_index_area_region()
    local m_tpWmapRegions = self.tpWmapRegions
    local m_tiAreaWmapId = self.tiAreaWmapId

    for _, pPair in ipairs(spairs(m_tpWmapRegions, function (a, b) return a < b end)) do
        local sWmapName
        local pWmapRegion
        sWmapName, pWmapRegion = unpack(pPair)

        local iWmapId = self:get_worldmap_id(sWmapName)
        for _, iMapid in ipairs(pWmapRegion:get_areas()) do
            m_tiAreaWmapId[iMapid] = iWmapId
        end
    end
end

function CFieldWorldmapTable:get_worldmapid_by_area(iMapid)
    local m_tiAreaWmapId = self.tiAreaWmapId
    return m_tiAreaWmapId[iMapid]
end

function CFieldWorldmapTable:get_worldmap_name_by_area(iMapid)
    local iWmapid = self:get_worldmapid_by_area(iMapid)
    return S_WORLDMAP_BASE .. string.format("%03d", iWmapid)
end

function CFieldWorldmapTable:contains(iMapid)
    local m_tiAreaWmapId = self.tiAreaWmapId
    return m_tiAreaWmapId[iMapid]
end
