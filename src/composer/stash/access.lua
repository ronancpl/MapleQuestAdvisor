--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("structs.quest.attributes.category.gender")
require("structs.quest.attributes.category.job")

local function fn_access_item_job(pPlayerState, siJob)
    return is_in_job_niche(siJob, pPlayerState:get_job())
end

local function fn_access_item_gender(pPlayerState, siGender)
    return is_in_gender(siGender, pPlayerState:get_gender())
end

local function fn_access_item_prop(iId, iCount, iProp, tiPropItems)
    tiPropItems[iId] = iCount
    return false                -- to select one item from all items having prop
end

local tiJobAttrNiche = {[1180673] = 0, [2099202] = 1, [4198404] = 2, [8200] = 3, [16400] = 4, [32800] = 5}
local function get_job_niche_by_attr(siJobAttr)
    local siNiche = tiJobAttrNiche[siJobAttr] or 0
    return siNiche
end

function fn_access_item(iId, iCount, iProp, siGender, siJob)
    if siJob == -1 and siGender == -1 and iProp == 0 then
        return nil
    end

    return function(pPlayerState, tiPropItems)
        local bRet = true
        if siJob ~= -1 then
            local siJobNiche = get_job_niche_by_attr(siJob) * 100
            bRet = bRet and fn_access_item_job(pPlayerState, siJobNiche)
        end

        if siGender ~= -1 then
            bRet = bRet and fn_access_item_gender(pPlayerState, siGender)
        end

        if iProp ~= 0 then
            bRet = bRet and fn_access_item_prop(iId, iCount, iProp, tiPropItems)
        end

        return bRet
    end
end
