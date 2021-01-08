--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

function keys(tTable)           -- keys as list
    local rgpKeys = {}

    if tTable ~= nil then
        for k, _ in pairs(tTable) do
            table.insert(rgpKeys, k)
        end
    end

    return rgpKeys
end

function unpack_keys(tTable)    -- unpacking keys as arguments
    return unpack(keys(tTable))
end

function clear_table(tTable)
    local rgpKeys = keys(tTable)
    for _, pKey in ipairs(rgpKeys) do
        tTable[pKey] = nil
    end
end

function create_inner_table_if_not_exists(tTable, pKey)
    local tInnerTable = tTable[pKey]

    if tInnerTable == nil then
        tInnerTable = {}
        tTable[pKey] = tInnerTable
    end

    return tInnerTable
end
