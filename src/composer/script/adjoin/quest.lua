--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("composer.script.adjoin.quest.assign")
require("composer.script.adjoin.quest.fetch")
require("composer.script.adjoin.quest.index")
require("composer.script.adjoin.util")

function append_quest_script_resources(tpDirRscs)
    -- adds functional resources on top of quest prerequisite/reward properties, if non-existent

    -- assumption: only script rewards are being accounted, as scripts report resources to START,
    -- even though resource progress flow linearly within START/END questing frame.

    local tpFieldQuests = make_remissive_index_unit_quests(ctQuests, fn_get_quest_fields)
    local tpNpcQuests = make_remissive_index_unit_quests(ctQuests, fn_get_quest_npcs)

    local tfn_dir_quests = fetch_table_directory_quest_method()

    for sDirName, tpScriptRscs in pairs(tpDirRscs) do
        local fn_dir_quests = tfn_dir_quests[sDirName]
        if fn_dir_quests ~= nil then
            for sScriptName, trgpTypeRscs in pairs(tpScriptRscs) do
                local rgpQuestProps = fn_dir_quests(sScriptName, tpFieldQuests)

                for sRscType, rgpRscs in pairs(trgpTypeRscs) do
                    local fn_apply_rsc = get_fn_apply_quest_resource(sRscType)

                    if fn_apply_rsc ~= nil then
                        for _, pQuestProp in ipairs(rgpQuestProps) do
                            apply_quest_resource_list(fn_apply_rsc, pQuestProp, rgpRscs)
                        end
                    end
                end
            end
        end
    end
end
