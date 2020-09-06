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
require("utils.provider.xml.provider")

function load_resources()
    SXmlProvider:init()

    ctQuests = load_resources_quests()
    --printable(ctQuests)

    ctFieldsDist = load_resources_fields()
    --printable(ctFieldsDist)

    ctFieldsMeta = load_more_resources_fields()
    --printable(ctFieldsMeta)

    ctNpcs, ctMobs, ctReactors = load_resources_units(ctFieldsMeta)
    --printable(ctNpcs)
    --printable(ctMobs)
    --printable(ctReactors)

    ctPlayersMeta = load_resources_player()
    --printable(ctPlayersMeta)

    ctLoots = load_resources_loots()
    --printable(ctLoots)

    ctMaker = load_resources_maker()
    --printable(ctMaker)
end

load_resources()
