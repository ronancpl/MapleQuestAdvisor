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

RCsvPlayer = {
    "iId", "sName", "siJob", "siLevel", "liExp", "iMapid", "iMeso", "siFame", "siGender"
}

function load_csv_player(sCsvPath)
    local tpItems = {}

    local rgpLines = read_csv_lines(sCsvPath, true)
    local rgpRow = rgpLines[2]

    for i = 1, #rgpRow, 1 do
        local pItem = rgpRow[i]
        tpItems[RCsvPlayer[i]] = pItem
    end

    local pPlayer = CPlayer:new({iId = 1})
    pPlayer:import_table(tpItems)

    return pPlayer
end
