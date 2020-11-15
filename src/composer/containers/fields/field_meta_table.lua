--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("utils.struct.class")

CFieldMetaTable = createClass({
    tFieldReturn = {},
    tFieldOverworld = {},
    tFieldStrings = {},
    tTownFields = {}
})

function CFieldMetaTable:is_town(iSrcid)
    return self.tTownFields[iSrcid] ~= nil
end

function CFieldMetaTable:get_towns()
    local rgiTowns = {}

    local m_tTownFields = self.tTownFields
    for iMapid, _ in pairs(m_tTownFields) do
        table.insert(rgiTowns, iMapid)
    end

    return rgiTowns
end

function CFieldMetaTable:add_field_return(iSrcid, iDestId)
    self.tFieldReturn[iSrcid] = iDestId
    self.tTownFields[iDestId] = 1
end

function CFieldMetaTable:get_field_return(iSrcid)
    return self.tFieldReturn[iSrcid]
end

function CFieldMetaTable:add_field_overworld(iSrcid, iDestId)
    self.tFieldOverworld[iSrcid] = iDestId
end

function CFieldMetaTable:get_field_overworld(iSrcid)
    return self.tFieldOverworld[iSrcid]
end

function CFieldMetaTable:set_field_name(iMapid, sStreetName, sMapName)
    self.tFieldStrings[iMapid] = {sStreetName, sMapName}
end

function CFieldMetaTable:get_street_name(iMapid)
    local pFieldName = self.tFieldStrings[iMapid]
    return pFieldName and pFieldName[2] or ""
end

function CFieldMetaTable:get_map_name(iMapid)
    local pFieldName = self.tFieldStrings[iMapid]
    return pFieldName and pFieldName[1] or ""
end

function CFieldMetaTable:get_area_name(iMapid)
    return self:get_street_name(iMapid) .. " - " .. self:get_map_name(iMapid)
end
