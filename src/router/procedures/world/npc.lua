--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

function get_npc_return_locations(iNpcid)
    local tReturnMapids = {}

    for _, iMapid in ipairs(ctNpcs:get_locations(iNpcid)) do
        local iRetMapid = ctFieldsMeta:get_field_return(iMapid)
        tReturnMapids[iRetMapid] = iMapid
    end

    return tReturnMapids
end

function get_npc_location(iNpcid, iPlayerMapid)
    local iPlayerRegionid = ctFieldsLandscape:get_region_by_mapid(iPlayerMapid)

    local rgiAbroadMapids = {}

    local iNpcMapid = nil
    local iNpcFieldDist = U_INT_MAX

    local tNpcMapids = ctNpcs:get_locations(iNpcid)
    for _, iMapid in pairs(tNpcMapids) do
        local iRegionid = ctFieldsLandscape:get_region_by_mapid(iMapid)
        if iRegionid == iPlayerRegionid then
            local iDist = ctFieldsLandscape:fetch_field_distance(iPlayerMapid, iMapid, ctFieldsDist, ctFieldsMeta, ctFieldsWmap, ctFieldsLink)
            if iDist < iNpcFieldDist then
                iNpcMapid = iMapid
                iNpcFieldDist = iDist
            end
        else
            table.insert(rgiAbroadMapids, iMapid)
        end
    end

    if iNpcMapid == nil then
        for _, iMapid in ipairs(rgiAbroadMapids) do
            local iDist = ctFieldsLandscape:fetch_field_distance(iPlayerMapid, iMapid, ctFieldsDist, ctFieldsMeta, ctFieldsWmap, ctFieldsLink)
            if iDist < iNpcFieldDist then
                iNpcMapid = iMapid
                iNpcFieldDist = iDist
            end
        end
    end

    if iNpcMapid == nil then
        local iRetMapid = ctFieldsMeta:get_field_return(iPlayerMapid)
        if tNpcMapids[iPlayerMapid] ~= nil then
            iNpcMapid = iPlayerMapid
        elseif tNpcMapids[iRetMapid] ~= nil then
            iNpcMapid = iRetMapid
        elseif #rgiAbroadMapids > 0 then
            for _, iMapid in ipairs(rgiAbroadMapids) do
                local iDist = ctFieldsLandscape:fetch_field_distance(iPlayerMapid, iMapid, ctFieldsDist, ctFieldsMeta, ctFieldsWmap, ctFieldsLink)
                if iDist < iNpcFieldDist then
                    iNpcMapid = iMapid
                    iNpcFieldDist = iDist
                end
            end
        end
    end

    return iNpcMapid
end
