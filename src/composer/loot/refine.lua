--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("composer.containers.loots.table.refine")
require("utils.provider.text.table")

local function load_refines_table(ctRefine, sFilePath)
    local tRefineEntries = read_plain_table(sFilePath)
    for _, rgpRefineEntry in ipairs(tRefineEntries) do
        local iCountToCreate = tonumber(rgpRefineEntry[1])
        local iItemidToCreate = tonumber(rgpRefineEntry[2])

        local rgpComposition = {}
        local nRefineEntry = #rgpRefineEntry
        for i = 3, nRefineEntry, 2 do
            local iItemid = tonumber(rgpRefineEntry[i])
            local iQty = tonumber(rgpRefineEntry[i + 1])

            table.insert(rgpComposition, {iItemid, iQty})
        end

        ctRefine:add_refine_entry(iItemidToCreate, iCountToCreate, rgpComposition)
    end
end

function load_resources_refine()
    local sDirPath = RPath.RSC_META_REFINES

    local ctRefine = CRefineTable:new()
    load_refines_table(ctRefine, sDirPath .. "/refine_ore.txt")
    load_refines_table(ctRefine, sDirPath .. "/refine_material.txt")

    ctRefine:make_remissive_index_item_referrer()

    return ctRefine
end
