--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

function split_tuples(nTupleLen, ...)
    -- fills remainder with nil

    local rgTuples = {}

    local tTable = ...

    local i
    for i = 1, #tTable, nTupleLen do
        local rgCt = {}
        for j = 0, nTupleLen - 1, 1 do
            table.insert(rgCt, tTable[i + j])
        end

        table.insert(rgTuples, rgCt)
    end

    return rgTuples
end
