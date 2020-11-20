--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("utils.provider.text.table")
require("containers.loots.table.refine")

local function load_refines_table(sFilePath)
    local ctRefines = CRefineTable:new()

    local tRefineEntries = read_plain_table(sFilePath)
    for _, rgpRefineEntry in ipairs(tRefineEntries) do
        local iItemidToCreate = tonumber(rgpRefineEntry[1])

        local rgpComposition = {}
        local nRefineEntry = #rgpRefineEntry
        for i = 2, nRefineEntry, 2 do
            local iItemid = tonumber(rgpRefineEntry[i])
            local iQty = tonumber(rgpRefineEntry[i + 1])

            table.insert(rgpComposition, {iItemid, iQty})
        end

        ctRefines:add_refine_entry(iItemidToCreate, rgpComposition)
    end

    ctRefines:make_remissive_index_item_referrer()

    return ctRefines
end

function load_resources_refine()
    local sDirPath = RPath.RSC_META_REFINES
    local sFilePath = sDirPath .. "/ore_refine.txt"

    local ctRefines = load_refines_table(sFilePath)
    return ctRefines
end
