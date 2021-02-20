--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

local SSet = require("pl.class").Set

function collection_copy(set)
    return SSet{unpack(set:values())}
end

function collection_values(set)
    local tpItems = {}

    for _, pItem in ipairs(set:values()) do
        tpItems[pItem] = 1
    end
    tpItems[{}] = nil   -- remove empty-table

    local rgpItems = {}
    for pItem, _ in pairs(tpItems) do
        table.insert(rgpItems, pItem)
    end

    return rgpItems
end
