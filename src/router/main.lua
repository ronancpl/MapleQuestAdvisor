--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

package.path = package.path .. ';?.lua'

require("composer.field.field");
require("composer.loot.loot");
require("composer.loot.maker");
require("composer.quest.quest");
require("composer.unit.unit");
require("composer.unit.player");
require("utils.print");

--qtQuests = load_resources_quests()
--printable(qtQuests)

--tFieldDist = load_resources_fields()
--printable(tFieldDist)

--tFieldMeta = load_more_resources_fields()
--load_resources_units(tFieldMeta)

tPlayerMeta = load_resources_player()
printable(tPlayerMeta)

--tLoots = load_resources_loots()
--printable(tLoots)

--tMaker = load_resources_maker()
--printable(tMaker)
