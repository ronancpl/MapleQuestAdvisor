--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("utils.array");
require("utils.class");

CInventory = createClass({
    rgEntries = {}
})

function CInventory:have_item(iId, iCount)
    return self.rgEntries[iId] ~= nil and self.rgEntries[iId] >= iCount
end

function CInventory:get_items()
    return self.rgEntries
end

function CInventory:add_item(iId, iCount)
    if self.rgEntries[iId] ~= nil then
        self.rgEntries[iId] = self.rgEntries[iId] + iCount
    else
        self.rgEntries[iId] = iCount
    end
end

function CInventory:remove_item(iId, iCount)
    if self.rgEntries[iId] ~= nil then
        self.rgEntries[iId] = self.rgEntries[iId] - iCount
        if self.rgEntries[iId] < 0 then
            self.rgEntries[iId] = nil
        end
    end
end
