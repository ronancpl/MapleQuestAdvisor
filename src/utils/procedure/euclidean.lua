--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

-- format: X1, X2, Y1, Y2, Z1, Z2...
function calc_distance(...)
    local iDist = 0

    local tTable = ...

    local nDims = math.floor(#tTable / 2)
    for i = 1, nDims, 1 do
        local iO1 = tTable[2 * nDims - 1]
        local iO2 = tTable[2 * nDims]

        iDist = iDist + (math.abs(iO1 - iO2) ^ 2)
    end

    return math.sqrt(iDist)
end
