--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

local function fetch_effective_unit_count_to_item(iId, iCount)

end

function fetch_inventory_split_count(ivtItems)
    local tiTypeCount = {}

    for iId, iCount in pairs(ivtItems:get_items()) do
        local iEffCount = fetch_effective_unit_count_to_item(iId, iCount)

        local iType = math.floor(iId / 1000000)
        tiTypeCount[iType] = (tiTypeCount[iType] or 0) + iCount
    end

    return tiTypeCount
end

function fetch_inventory_count(ivtItems)
    local iRetCount = 0

    for _, iCount in pairs(ivtItems:get_items()) do
        iRetCount = iRetCount + iCount
    end

    return iRetCount
end
