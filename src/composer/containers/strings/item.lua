--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("composer.containers.strings.table.meta_table")
require("composer.string.item")

function load_meta_resources_items()
    local ctItemsMeta = CEntryMetaTable:new()

    local tsItemName, tsItemDesc = load_item_string()

    for iId, sName in pairs(tsItemName) do
        local sDesc = tsItemDesc[iId]
        ctItemsMeta:set_text(iId, {sName, sDesc})
    end

    return ctItemsMeta
end
