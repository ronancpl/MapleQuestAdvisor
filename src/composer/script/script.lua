--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("composer.containers.scripts.resources.gain")
require("composer.containers.scripts.resources.quest")
require("composer.containers.scripts.resources.spawn")
require("utils.procedure.string")
require("utils.provider.xml.provider")

local function fn_get_resource_gain(pListItemNode, sType)
    local iId = pListItemNode:get_child_by_name("id"):get_value()
    local iCount = pListItemNode:get_child_by_name("count"):get_value()

    return CScriptGain:new({iId = iId, iCount = iCount, sType = sType})
end

local function fn_get_resource_quest(pListItemNode, sType)
    local iId = pListItemNode:get_child_by_name("id"):get_value()

    return CScriptQuest:new({iId = iId, sType = sType})
end

local function fn_get_resource_spawn(pListItemNode, sType)
    local iId = pListItemNode:get_child_by_name("id"):get_value()

    return CScriptSpawn:new({iId = iId, sType = sType})
end

local function load_resources_from_quest_resource_type(pRscTypeNode, sTypeName, fn_get_rsc)
    local tpRscs = {}
    for _, pListItemNode in pairs(pRscTypeNode:get_children()) do
        local pRsc = fn_get_rsc(pListItemNode, sTypeName)

        local iId = pRsc:get_id()
        local pCurRsc = tpRscs[iId]

        if not (pCurRsc ~= nil and pCurRsc.get_count ~= nil and pCurRsc:get_count() >= pRsc:get_count()) then
            tpRscs[iId] = pRsc
        end
    end

    local rgiRscs = {}
    for _, pRsc in pairs(tpRscs) do
        table.insert(rgiRscs, pRsc)
    end

    return rgiRscs
end

local function load_script_file_resources(pScriptNode)
    local trgpFileRscs = {}

    for _, pRscTypeNode in pairs(pScriptNode:get_children()) do
        local sTypeName = pRscTypeNode:get_name()

        local rgpRscs
        if string.starts_with(sTypeName, "Gain") then
            rgpRscs = load_resources_from_quest_resource_type(pRscTypeNode, sTypeName, fn_get_resource_gain)
        elseif string.ends_with(sTypeName, "Quest") then
            rgpRscs = load_resources_from_quest_resource_type(pRscTypeNode, sTypeName, fn_get_resource_quest)
        elseif string.starts_with(sTypeName, "Spawn") then
            rgpRscs = load_resources_from_quest_resource_type(pRscTypeNode, sTypeName, fn_get_resource_spawn)
        end

        trgpFileRscs[sTypeName] = rgpRscs
    end

    return trgpFileRscs
end

local function load_script_directory_node_resources(pDirRscsNode)
    local tpDirRscs = {}

    for _, pScriptNode in pairs(pDirRscsNode:get_children()) do
        local trgpFileRscs = load_script_file_resources(pScriptNode)

        local i = 0
        for sName, rgpRscs in pairs(trgpFileRscs) do
            i = i + #rgpRscs
        end

        tpDirRscs[pScriptNode:get_name()] = trgpFileRscs
    end

    return tpDirRscs
end

local function load_script_directory_xml_resources(sScriptDirName)
    local sDirPath = RPath.RSC_META_SCRIPTS
    local sScriptDirPath = sDirPath .. "/" .. sScriptDirName .. ".xml"

    local pScriptDirNode = SXmlProvider:load_xml(sScriptDirPath)
    local sScriptImgName = sScriptDirName .. ".img"

    local pDirRscsNode = pScriptDirNode:get_child_by_name(sScriptImgName)

    local tpDirRscs = load_script_directory_node_resources(pDirRscsNode)
    return tpDirRscs
end

function load_script_directory_resources()
    local sDirPath = RPath.RSC_META_SCRIPTS
    local sScriptDirPath = sDirPath

    local rgsScriptDirs = {"event", "map", "npc", "portal", "quest", "reactor"}
    local tpDirScriptRscs = {}
    for _, sDirName in ipairs(rgsScriptDirs) do
        tpDirScriptRscs[sDirName] = load_script_directory_xml_resources(sDirName)
    end

    SXmlProvider:unload_node(sDirPath)   -- free XMLs nodes: Scripts

    return tpDirScriptRscs
end
