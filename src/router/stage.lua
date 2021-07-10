--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

package.path = package.path .. ';?.lua'

require("router.procedures.quest.accessors")
require("router.procedures.quest.awarders")
require("router.stages.load")
require("router.stages.map")

load_resources()

load_regions_overworld(ctFieldsDist, ctFieldsLink)
load_distances_overworld(ctFieldsLandscape, ctFieldsDist, ctFieldsMeta, ctFieldsWmap, ctFieldsLink)

load_script_resources()
load_loot_retrieval_resources()

ctAccessors = init_quest_accessors()
ctAwarders = init_quest_awarders()
