--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("router.procedures.userdata.common")

function load_csv_rates(sCsvPath)
    local tpItems = {}

    local rgpLines = read_csv_lines(sCsvPath, true)
    local rgiRow = rgpLines[2]

    local siExpRate = rgiRow[1]
    local siMesoRate = rgiRow[2]
    local siDropRate = rgiRow[3]

    return siExpRate, siMesoRate, siDropRate
end
