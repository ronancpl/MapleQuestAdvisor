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
require("structs.storage.inventory")

function load_csv_inventory(pPlayer, sCsvPath, fn_get_invt)
    local rgpLines = read_csv_lines(sCsvPath, true)

    local pInvt = CInventory:new()
    for i = 2, #rgpLines, 1 do
        local rgiRow = rgpLines[i]

        local iId = rgiRow[1]
        local iQty = rgiRow[2]

        pInvt:add_item(iId, iQty)
    end

    local pIvtItems = fn_get_invt(pPlayer)
    pIvtItems:include_inventory(pInvt)
end
