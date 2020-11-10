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
    for k, _ in pairs(tTable) do
        table.insert(rgpKeys, k)
    end

    return unpack(k)
end

function unpack_keys(tTable)    -- unpacking keys as arguments
    return unpack(keys(tTable))
end
