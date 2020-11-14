--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("utils.procedure.unpack")

local function outline_area_outskirts(iMapid, tiExploredMapids, tFrontierMapids, ctFieldsDist)
    tiExploredMapids[iMapid] = 1

    local tiNeighborMapids = ctFieldsDist:get_field_distances(iMapid)
    for iMapid, _ in pairs(tiNeighborMapids) do
        if tiExploredMapids[iMapid] == nil then
            table.insert(tFrontierMapids, iMapid)
        end
    end
end

local function scan_regional_areas(iMapidSeed, ctFieldsDist)
    local tiExploredMapids = {}

    local tFrontierMapids = {}
    table.insert(tFrontierMapids, iMapidSeed)

    while true do
        local iMapid = table.remove(tFrontierMapids)
        if iMapid == nil then
            break
        end

        outline_area_outskirts(iMapid, tiExploredMapids, tFrontierMapids, ctFieldsDist)
    end

    return SSet{unpack_keys(tiExploredMapids)}
end

function fetch_regional_areas(ctFieldsDist, ctFieldsMeta)
    local rgpSetRegionAreas = {}

    local rgiMapids = ctFieldsMeta:get_field_entries()
    local pSetRemaining = SSet{unpack(rgiMapids)}
    for _, iMapid in pairs(rgiMapids) do
        local pSetMapid = SSet{iMapid}
        if pSetMapid:is_subset(pRemainingSet) then
            local pSetRegional = scan_regional_areas(iMapid, ctFieldsDist)

            table.insert(rgpSetRegionAreas, pSetRegional)
            pSetRemaining = pSetRemaining - pSetRegional
        end
    end

    return rgpSetRegionAreas
end
