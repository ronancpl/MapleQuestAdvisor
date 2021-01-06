--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("utils.procedure.string")

local function fn_quest_rsc_value(iCount)
    local bReq = iCount < 0
    if bReq then
        iCount = -iCount
    end

    return bReq, iCount
end

local function fn_apply_quest_rsc_item(pQuestProp, fn_quest_ivt, iId, iGain)
    local bReq
    local iCount
    bReq, iCount = fn_quest_rsc_value(iGain)

    if bReq then
        --[[
        local pQuestChkProp = pQuestProp:get_requirement()
        local ivtValue = fn_quest_ivt(pQuestChkProp)

        if ivtValue:get_item(iId) < iCount then     -- only updates if the current scenario lacks in comparison
            ivtValue:set_item(iId, iCount)
        end
        ]]--
    else
        local pQuestActProp = pQuestProp:get_action()
        local ivtValue = fn_quest_ivt(pQuestActProp)

        if ivtValue:get_item(iId) < iCount then
            ivtValue:set_item(iId, iCount)
        end
    end
end

local function fn_apply_quest_rsc_attr(pQuestProp, fn_quest_attr_get, fn_quest_attr_set, iGain)
    local bReq
    local iCount = fn_quest_rsc_value(iGain)

    if bReq then
        --[[
        local pQuestChkProp = pQuestProp:get_requirement()
        if fn_quest_attr_get(pQuestChkProp) < iCount then
            fn_quest_attr_set(pQuestChkProp, iCount)
        end
        ]]--
    else
        local pQuestActProp = pQuestProp:get_action()
        if fn_quest_attr_get(pQuestActProp) < iCount then
            fn_quest_attr_set(pQuestActProp, iCount)
        end
    end
end

local function apply_quest_resource_gain_item(pQuestProp, pRsc)
    local iId = pRsc:get_id()
    local iCount = pRsc:get_count()

    fn_apply_quest_rsc_item(pQuestProp, CQuestProperty.get_items, iId, iCount)
end

local function apply_quest_resource_gain_skill(pQuestProp, pRsc)
    local iId = pRsc:get_id()

    fn_apply_quest_rsc_item(pQuestProp, CQuestProperty.get_skills, iId, 1)
end

local function apply_quest_resource_gain_exp(pQuestProp, pRsc)
    local iId = pRsc:get_id()

    fn_apply_quest_rsc_attr(pQuestProp, CQuestProperty.get_exp, CQuestProperty.set_exp, iId)
end

local function apply_quest_resource_gain_meso(pQuestProp, pRsc)
    local iId = pRsc:get_id()

    fn_apply_quest_rsc_attr(pQuestProp, CQuestProperty.get_meso, CQuestProperty.set_meso, iId)
end

local function apply_quest_resource_gain_fame(pQuestProp, pRsc)
    local iId = pRsc:get_id()

    fn_apply_quest_rsc_attr(pQuestProp, CQuestProperty.get_fame, CQuestProperty.set_fame, iId)
end

local function apply_quest_resource_quest_start(pQuestProp, pRsc)
    local iId = pRsc:get_id()

    fn_apply_quest_rsc_item(pQuestProp, CQuestProperty.get_quests, iId, 1)
end

local function apply_quest_resource_quest_complete(pQuestProp, pRsc)
    local iId = pRsc:get_id()

    fn_apply_quest_rsc_item(pQuestProp, CQuestProperty.get_quests, iId, 2)
end

function get_fn_apply_quest_resource(sTypeName)
    if string.starts_with(sTypeName, "Gain") then
        if string.ends_with(sTypeName, "Item") then
            return apply_quest_resource_gain_item
        elseif string.ends_with(sTypeName, "Skill") then
            return apply_quest_resource_gain_skill
        elseif string.ends_with(sTypeName, "Exp") then
            return apply_quest_resource_gain_exp
        elseif string.ends_with(sTypeName, "Meso") then
            return apply_quest_resource_gain_meso
        elseif string.ends_with(sTypeName, "Fame") then
            return apply_quest_resource_gain_fame
        end
    elseif string.ends_with(sTypeName, "Quest") then
        if string.ends_with(sTypeName, "Start") then
            return apply_quest_resource_quest_start
        elseif string.ends_with(sTypeName, "Complete") then
            return apply_quest_resource_quest_complete
        end
    end

    return nil
end

local function apply_quest_resource(fn_apply_rsc, pQuestProp, pRsc)
    fn_apply_rsc(pQuestProp, pRsc)
end

function apply_quest_resource_list(fn_apply_rsc, pQuestProp, rgpRscs)
    for _, pRsc in ipairs(rgpRscs) do
        apply_quest_resource(fn_apply_rsc, pQuestProp, pRsc)
    end
end
