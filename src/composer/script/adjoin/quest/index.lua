--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

local function add_index_unit_quests(tpUnitQuests, fn_get_units, pQuestProp)
    local rgiUnits = fn_get_units(pQuestProp)

    for _, iUnitid in ipairs(rgiUnits) do
        local rgpQuestProps = tpUnitQuests[iUnitid]
        if rgpQuestProps == nil then
            rgpQuestProps = {}
            tpUnitQuests[iUnitid] = rgpQuestProps
        end
        table.insert(rgpQuestProps, pQuestProp)
    end
end

function make_remissive_index_unit_quests(ctQuests, fn_get_quest_units)
    local tpUnitQuests = {}

    for _, pQuest in pairs(ctQuests:get_quests()) do
        local pQuestProp
        pQuestProp = pQuest:get_start()
        add_index_unit_quests(tpUnitQuests, fn_get_quest_units, pQuestProp)

        pQuestProp = pQuest:get_end()
        add_index_unit_quests(tpUnitQuests, fn_get_quest_units, pQuestProp)
    end

    return tpUnitQuests
end
