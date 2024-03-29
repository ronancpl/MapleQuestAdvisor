--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("utils.procedure.copy")
require("utils.procedure.unpack")
require("utils.struct.array")
require("utils.struct.class")

CInventory = createClass({
    rgEntries = {},
    nSize = 0
})

function CInventory:has_item(iId, iCount)
    return self.rgEntries[iId] ~= nil and self.rgEntries[iId] >= iCount
end

function CInventory:get_item(iId)
    local iCount = self.rgEntries[iId]
    return iCount or 0
end

function CInventory:get_items()
    return self.rgEntries
end

function CInventory:size()
    return self.nSize
end

function CInventory:_add_item(iId, iCount)
    if self.rgEntries[iId] ~= nil then
        self.rgEntries[iId] = self.rgEntries[iId] + iCount
    else
        self.rgEntries[iId] = iCount
        self.nSize = self.nSize + 1
    end
end

function CInventory:_remove_item(iId, iCount)
    if self.rgEntries[iId] ~= nil then
        if iCount == nil then
            iCount = self.rgEntries[iId]
        end

        self.rgEntries[iId] = self.rgEntries[iId] - iCount
        if self.rgEntries[iId] <= 0 then
            self.rgEntries[iId] = nil
            self.nSize = self.nSize - 1
        end
    end
end

function CInventory:remove_item(iId, iCount)
    if iCount ~= nil and iCount < 0 then
        self:_add_item(iId, -iCount)
    else
        self:_remove_item(iId, iCount)
    end
end

function CInventory:add_item(iId, iCount)
    if iCount ~= nil then
        if iCount > -1 then
            self:_add_item(iId, iCount)
        else
            self:_remove_item(iId, -iCount)
        end
    end
end

function CInventory:set_item(iId, iCount)
    if self.rgEntries[iId] ~= nil then
        if iCount > 0 then
            self.rgEntries[iId] = iCount
        else
            self:remove_item(iId, self.rgEntries[iId])
        end
    else
        self.rgEntries[iId] = iCount
        self.nSize = self.nSize + 1
    end
end

function CInventory:include_inventory(ivtInventory)
    local rgEntries = ivtInventory:get_items()
    for iId, iCount in pairs(rgEntries) do
        self:add_item(iId, iCount)
    end
end

function CInventory:empty()
    for _, iId in pairs(keys(self:get_items())) do
        self:remove_item(iId)
    end
end

function CInventory:export_table()
    local tpItems = {}
    for iId, iCount in pairs(self:get_items()) do
        tpItems["\"" .. tostring(iId) .. "\""] = iCount
    end

    return tpItems
end

function CInventory:import_table(tpItems)
    self:empty()

    for sId, iCount in pairs(tpItems) do
        self:add_item(tonumber(sId:sub(2, -2)), tonumber(iCount))
    end
end

function CInventory:tostring()
    local st = ""
    for iId, iCount in pairs(self:get_items()) do
        st = st .. iId .. ":" ..  iCount .. ", "
    end

    return "[" .. st .. "]"
end

function CInventory:debug_inventory()
    print(self:tostring())
end
