--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

function fn_get_entry_key(bIntUnit)
    if bIntUnit then
        return function(sScriptName) return tonumber(string.sub(sScriptName, 0, -4)) end    -- removes ".js"
    else
        return function(sScriptName) return string.sub(sScriptName, 0, -4) end
    end
end

function fetch_field_quests(rgiMapids, tpFieldQuests)
    local tQuests = {}

    for _, iMapid in ipairs(rgiMapids) do
        local rgpQuestProps = tpFieldQuests[iMapid]
        if rgpQuestProps ~= nil then
            for _, pQuestProp in ipairs(rgpQuestProps) do
                tQuests[pQuestProp] = 1
            end
        end
    end

    return keys(tQuests)
end

function fn_get_quest_fields(pQuestProp)
    local tFields = {}  -- adds fields from quest requirements: NPC & field enter

    local pQuestChkProp = pQuestProp:get_requirement()

    local tiFieldsEnter = pQuestChkProp:get_field_enter()
    for iFieldEnter, _ in ipairs(tiFieldsEnter) do
        tFields[iFieldEnter] = 1
    end

    local iNpcid = pQuestChkProp:get_npc()
    for _, iMapid in ipairs(ctNpcs:get_locations(iNpcid)) do
        tFields[iMapid] = 1
    end

    return keys(tFields)
end

function fn_get_quest_npcs(pQuestProp)
    local tNpcs = {}

    local pQuestChkProp = pQuestProp:get_requirement()

    local iNpcid = pQuestChkProp:get_npc()
    tNpcs[iNpcid] = 1

    return keys(tNpcs)
end
