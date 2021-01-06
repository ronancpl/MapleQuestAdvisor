--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("composer.containers.units.mob_group_table")
require("utils.procedure.directory")

local function load_mob_group(sFileName, pMobGroupsNode)
    local pMobGroupsImgNode = pMobGroupsNode:get_child_by_name(string.sub(sFileName, 0, -5))    -- removes ".xml"

    local iGroupMobid = tonumber(string.sub(pMobGroupsImgNode:get_name(), 0, -5))
    local rgiMobids = {}

    local pGroupNode = pMobGroupsImgNode:get_child_by_name("info")
    for _, pMobNode in pairs(pGroupNode:get_children()) do
        local iMobid = pMobNode:get_value()
        table.insert(rgiMobids, iMobid)
    end

    return iGroupMobid, rgiMobids
end

local function load_resources_mob_quest_group_file(ctMobsGroup, sMobGroupsDirPath, sFileName)
    local pMobGroupsNode = SXmlProvider:load_xml(sMobGroupsDirPath .. "/" .. sFileName)

    local iGroupMobid
    local rgiMobids
    iGroupMobid, rgiMobids = load_mob_group(sFileName, pMobGroupsNode)

    ctMobsGroup:add_entry(iGroupMobid)
    for _, iMobid in ipairs(rgiMobids) do
        ctMobsGroup:add_location(iGroupMobid, iMobid)   -- mob group with "location" as a proxy
    end
end

function load_resources_mob_quest_group_count()
    local sDirPath = RPath.RSC_MOBS
    local sMobGroupsDirPath = sDirPath .. "/QuestCountGroup"

    local ctMobsGroup = CMobGroupTable:new()

    for _, sFileName in ipairs(scandir(sMobGroupsDirPath)) do
        load_resources_mob_quest_group_file(ctMobsGroup, sMobGroupsDirPath, sFileName)
    end

    SXmlProvider:unload_node(sMobGroupsDirPath)   -- free XMLs nodes: QuestCountGroup
    return ctMobsGroup
end
