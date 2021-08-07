--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("utils.procedure.splitter")

-- format: X1, X2, Y1, Y2, Z1, Z2...
function calc_distance(...)
    local iDist = 0

    local rgCoords = split_tuples(2, ...)
    for _, pCoords in ipairs(rgCoords) do
        local iO1, iO2 = unpack(pCoords)

        iDist = iDist + (math.abs(iO1 - iO2) ^ 2)
    end

    return math.sqrt(iDist)
end

function calc_word_distance(iNum1, iNum2)
    local iDist = 0

    repeat
        local i1 = iNum1 % 10
        local i2 = iNum2 % 10
        iDist = iDist + math.abs(i1 - i2)

        iNum1 = math.floor(iNum1 / 10)
        iNum2 = math.floor(iNum2 / 10)
    until iNum1 == 0 and iNum2 == 0

    return iDist
end
