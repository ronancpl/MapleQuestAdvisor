--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("utils/provider/xml/node")

local function parse_dom_node_childs(pTreeNode, tFileNodeChilds)
    pN = table.remove(tFileNodeChilds)  -- avoid handling child N

    for _, pChildFileNode in pairs(tFileNodeChilds) do
        pChildTreeNode = parse_dom_node(pChildFileNode)
        pTreeNode:add_child(pChildTreeNode)
    end

    table.insert(tFileNodeChilds, pN)   -- adds back child N
end

local tfn_parse_attr = {
    -- ["imgdir"] = function (x)  end,
    -- ["canvas"] = function (x)  end,
    -- ["convex"] = function (x)  end,
    -- ["sound"] = function (x)  end,
    -- ["uol"] = function (x)  end,
    ["double"] = function (x) tonumber(x) end,
    ["float"] = function (x) tonumber(x) end,
    ["int"] = function (x) tonumber(x) end,
    ["short"] = function (x) return tonumber(x) end,
    ["string"] = function (x) return x end,
    -- ["vector"] = function (x) return  end,
    -- ["null"] = function (x)  return  end,
}

local function parse_dom_data_attribute(sName, sValue)
    fn_data_attr = tfn_parse_attr[sName]
    if fn_data_attr ~= nil then
        return fn_data_attr(sValue)
    else
        return nil
    end
end

local function parse_dom_node_attributes(pTreeNode, tFileNodeAttrs)
    local sDataType = pTreeNode:get_name()
    -- local tAttr = pTreeNode:get_attr()

    local sName = tFileNodeAttrs["name"]
    local sValue = tFileNodeAttrs["value"]

    local uValue = parse_dom_data_attribute(sDataType, sValue)
    pTreeNode:set("name", sName)
    pTreeNode:set("value", uValue)
end

local function parse_dom_node(pFileNode)
    pTreeNode = CXmlNode:new()

    pTreeNode:set_type(pFileNode["_type"])
    pTreeNode:set_name(pFileNode["_name"])

    parse_dom_node_attributes(pTreeNode, pFileNode["_attr"])
    parse_dom_node_childs(pTreeNode, pFileNode["_children"])

    return pTreeNode
end

function parse_dom_file(pFileDom)
    pTreeDom = parse_dom_node(pFileDom)
    return pTreeDom
end
