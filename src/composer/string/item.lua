--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("router.constants.path")
require("utils.provider.xml.provider")

local function load_item_names(pItemListNode, tsItemName, tsItemDesc)
    for _, pItemNode in pairs(pItemListNode:get_children()) do
        local iItemid = pItemNode:get_name_tonumber()

        local pNameNode = pItemNode:get_child_by_name("name")
        local sItemName = pNameNode and pNameNode:get_value() or ""

        local pDescNode = pItemNode:get_child_by_name("desc")
        local sItemDesc = pDescNode and pDescNode:get_value() or ""

        tsItemName[iItemid] = sItemName
        tsItemDesc[iItemid] = sItemDesc
    end
end

local function load_eqp_dir_string(tsItemName, tsItemDesc)
    local sItemStringsPath = RPath.RSC_STRINGS .. "/Eqp.img.xml"

    local pItemStringNode = SXmlProvider:load_xml(sItemStringsPath)

    local pEqpTypesNode = pItemStringNode:get_child_by_name("Eqp.img/Eqp")
    for _, pEqpListNode in pairs(pEqpTypesNode:get_children()) do
        load_item_names(pEqpListNode, tsItemName, tsItemDesc)
    end
end

local function load_item_dir_string(tsItemName, tsItemDesc, sDirName)
    local iIdx = string.find(sDirName, ".img")
    local sXmlName = sDirName:sub(1, iIdx + 3)

    local sItemStringsPath = RPath.RSC_STRINGS .. "/" .. sXmlName .. ".xml"
    local pItemStringNode = SXmlProvider:load_xml(sItemStringsPath)

    local pItemListNode = pItemStringNode:get_child_by_name(sDirName)
    load_item_names(pItemListNode, tsItemName, tsItemDesc)
end

function load_item_string()
    local sDirPath = RPath.RSC_STRINGS

    local tsItemName = {}
    local tsItemDesc = {}

    load_eqp_dir_string(tsItemName, tsItemDesc)
    load_item_dir_string(tsItemName, tsItemDesc, "Consume.img")
    load_item_dir_string(tsItemName, tsItemDesc, "Ins.img")
    load_item_dir_string(tsItemName, tsItemDesc, "Etc.img/Etc")
    load_item_dir_string(tsItemName, tsItemDesc, "Cash.img")

    SXmlProvider:unload_node(sDirPath)   -- free XMLs nodes: String

    return tsItemName, tsItemDesc
end
