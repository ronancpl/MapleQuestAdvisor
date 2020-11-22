--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

function maker_add_item(ivtItems, iId, iQty)
    local rgpUpdated = {}
    table.insert(rgpUpdated, {iId, iQty})

    while true do
        local pUpdated = table.remove(rgpUpdated)
        if pUpdated == nil then
            break
        end

        local iItemid
        local iCount
        iItemid, iCount = unpack(pUpdated)

        local iIvtCount = ivtItems:get_item(iItemid)
        local iDiff = iIvtCount + iCount
        if iDiff < 0 then
            ivtItems:add_item(iItemid, -iIvtCount)

            local pReq = ctMaker:get_maker_requirement(iItemid)
            if pReq ~= nil then
                local iReqItemid
                local iReqCount
                iReqItemid, iReqCount = pReq

                table.insert({iReqItemid, iReqCount * iDiff})
            end
        else
            ivtItems:add_item(iItemid, iCount)
        end
    end
end

function maker_get_item(ivtItems, iId)
    local iQty = 0

    local iReqItemid = iId
    local iReqQty = 1
    while true do
        local iCount = ivtItems:get_item(iReqItemid)
        iQty = iQty + math.floor(iCount / iReqQty)

        local pReq = ctMaker:get_maker_requirement(iReqItemid)
        if pReq == nil then
            break
        end

        iReqItemid, iReqQty = pReq
    end

    return iQty
end
