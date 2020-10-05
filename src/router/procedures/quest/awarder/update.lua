--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("structs.storage.inventory")

function fn_undo_unit(iGet)
    return -iGet
end

function fn_undo_invt_insert(rgpGet)
    local rgpNew = CInventory:new()
    for iId, _ in ipairs(rgpGet:get_items()) do
        rgpNew:add(iId, 0)
    end

    return rgpNew
end

function fn_undo_invt_add(rgpGet)
    local rgpNew = CInventory:new()
    for iId, iCount in ipairs(rgpGet:get_items()) do
        rgpNew:add(iId, -iCount)
    end

    return rgpNew
end

function fn_undo_no_change(rgpGet)
    return rgpGet
end
