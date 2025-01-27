--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("utils.procedure.unpack")

local function get_item_count(ivtRaw, ivtComp, iId)
    return ivtRaw:get_item(iId) + ivtComp:get_item(iId)
end

local function unpack_inventories(ivtEx)
    return ivtEx:get_raw(), ivtEx:get_composite()
end

local function handlify_upper(ctRefine, ivtEx, iId, iQty)
    local rgpUpdated = {}
    table.insert(rgpUpdated, {iId, iQty})

    local ivtRaw
    local ivtComp
    ivtRaw, ivtComp = unpack_inventories(ivtEx)

    while true do
        local pItemUpdate = table.remove(rgpUpdated)
        if pItemUpdate == nil then
            break
        end

        local iItemid
        local iCount
        iItemid, iCount = unpack(pItemUpdate)

        ivtEx:apply_limit(iItemid, iCount)

        local rgiRefs = ctRefine:get_item_referrers(iItemid)
        if rgiRefs ~= nil then
            for _, iRefid in ipairs(rgiRefs) do
                local iRefineCount, pRefineEntry = ctRefine:get_refine_entry(iRefid)

                local tiComp = pRefineEntry:get_composition()
                local iReqCount = tiComp[iItemid]

                iCount = get_item_count(ivtRaw, ivtComp, iItemid)
                local iCompCount = math.floor(iCount / iReqCount)

                if iCompCount ~= ivtComp:get_item(iRefid) then
                    local rgiCompids = keys(tiComp)

                    ivtEx:apply_limit_if_not_exists(rgiCompids, 0)
                    local iRefCount = ivtEx:get_limit(tiComp, rgiCompids, iRefineCount)

                    ivtComp:set_item(iRefid, iRefCount)
                    table.insert(rgpUpdated, {iRefid, iRefCount})
                end
            end
        end
    end
end

local function handlify_lower(ctRefine, ivtRaw, ivtComp, iId, iQty)
    local tpCompUpdt = {}

    if iQty > -1 then
        ivtRaw:add_item(iId, iQty)
    else
        local iRawCount = ivtRaw:get_item(iId)
        local iNextCount = iRawCount + iQty

        if iNextCount < 0 then
            ivtRaw:add_item(iId, -iRawCount)
            ivtComp:add_item(iId, iNextCount)

            local _, pRefineEntry = ctRefine:get_refine_entry(iId)
            if pRefineEntry ~= nil then
                for iReqId, iReqCount in pairs(pRefineEntry:get_composition()) do
                    tpCompUpdt[iReqId] = ((tpCompUpdt[iReqId] or 0) + iNextCount) * iReqCount
                end
            end
        else
            ivtRaw:add_item(iId, iQty)
        end
    end

    return tpCompUpdt
end

function add_item(ivtEx, iId, iQty)
    ivtEx:commit_reload()

    local ivtRaw
    local ivtComp
    ivtRaw, ivtComp = unpack_inventories(ivtEx)

    local rgpUpdated = {}
    table.insert(rgpUpdated, {iId, iQty})

    while true do
        local pItemUpdate = table.remove(rgpUpdated)
        if pItemUpdate == nil then
            break
        end

        local iItemid
        local iCount
        iItemid, iCount = unpack(pItemUpdate)

        local tpCompRmvd = handlify_lower(ctRefine, ivtRaw, ivtComp, iItemid, iCount)
        handlify_upper(ctRefine, ivtEx, iItemid, get_item_count(ivtRaw, ivtComp, iItemid))

        for iCompItemid, iCompCount in pairs(tpCompRmvd) do
            table.insert(rgpUpdated, {iCompItemid, iCompCount})
        end
    end
end

function count_item(ivtEx, iId)
    local ivtRaw
    local ivtComp
    ivtRaw, ivtComp = unpack_inventories(ivtEx)

    return get_item_count(ivtRaw, ivtComp, iId)
end
