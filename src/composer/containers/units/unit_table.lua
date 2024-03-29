--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("utils.procedure.unpack")
require("utils.struct.class")

CUnitTable = createClass({
    sRscName = "",
    tUnitFields = {}
})

function CUnitTable:add_entry(iSrcid)
    if self.tUnitFields[iSrcid] == nil then
        self.tUnitFields[iSrcid] = {}
    end
end

function CUnitTable:add_location(iSrcid, iMapid)
    local tFields = self.tUnitFields[iSrcid]
    tFields[iMapid] = 1
    tFields["TABLE"] = nil
end

function CUnitTable:get_locations(iSrcid)
    local tFields = self.tUnitFields[iSrcid]

    local rgiFields
    if tFields ~= nil then
        rgiFields = tFields["TABLE"]
        if rgiFields == nil then
            rgiFields = {}
            for iMapid, _ in pairs(tFields) do
                table.insert(rgiFields, iMapid)
            end

            tFields["TABLE"] = rgiFields
        end
    else
        rgiFields = {}
    end

    return rgiFields
end

function CUnitTable:get_keys()
    return keys(self.tUnitFields)
end

function CUnitTable:debug_locations()
    log(LPath.PROCEDURES, "resources_location.txt", "Resource '" .. self.sRscName .. "' fields:")

    for iSrcid, tFields in pairs(self.tUnitFields) do
        local rgiFields = tFields

        local st = ""
        for iField, _ in pairs(rgiFields) do
            st = st .. iField .. ", "
        end
        log(LPath.PROCEDURES, "resources_location.txt", iSrcid .. " : [" .. st .. "]")
    end

end
