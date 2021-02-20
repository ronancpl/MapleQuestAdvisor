--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("utils.provider.xml.node")

local function parse_dom_node_children(pTreeNode, tFileNodeChildren)
    for _, pChildFileNode in ipairs(tFileNodeChildren) do
        local pChildTreeNode = _parse_dom_node(pChildFileNode)
        pTreeNode:add_child(pChildTreeNode)
    end
end

local tfn_parse_attr = {
    -- ["imgdir"] = function (x) return  end,
    -- ["canvas"] = function (x) return  end,
    -- ["convex"] = function (x) return  end,
    -- ["sound"] = function (x) return  end,
    -- ["uol"] = function (x) return  end,
    ["double"] = function (x) return tonumber(x) end,
    ["float"] = function (x) return tonumber(x) end,
    ["int"] = function (x) return tonumber(x) end,
    ["short"] = function (x) return tonumber(x) end,
    ["string"] = function (x) return x end,
    -- ["vector"] = function (x) return  end,
    -- ["null"] = function (x) return  end,
}

local function parse_dom_node_attribute(sName, sValue)
    local fn_parse_attr = tfn_parse_attr[sName]
    if fn_parse_attr ~= nil then
        return fn_parse_attr(sValue)
    else
        return nil
    end
end

local function parse_dom_node_attributes(pTreeNode, tFileNodeAttrs)
    local sNodeType = pTreeNode:get_type()
    -- local tAttr = pTreeNode:get_attr()

    local sName = tFileNodeAttrs["name"]
    local sValue = tFileNodeAttrs["value"]

    local uValue = parse_dom_node_attribute(sNodeType, sValue)
    pTreeNode:set("name", sName)
    pTreeNode:set("value", uValue)
end

function _parse_dom_node(pFileNode)
    local pTreeNode = CXmlNode:new()

    pTreeNode:set_node_type(pFileNode["_type"])
    pTreeNode:set_type(pFileNode["_name"])

    parse_dom_node_attributes(pTreeNode, pFileNode["_attr"])
    parse_dom_node_children(pTreeNode, pFileNode["_children"])

    pTreeNode:set_name(pTreeNode:get("name"))

    return pTreeNode
end

function _build_dom_root(pTreeDom)
    local pTreeRoot = CXmlNode:new()

    pTreeRoot:set_node_type("ROOT")
    pTreeRoot:set_type("")
    pTreeRoot:set_name("")
    pTreeRoot:add_child(pTreeDom)

    return pTreeRoot
end

function parse_dom_file(pFileDom)
    local pTreeDom = _parse_dom_node(pFileDom)
    return _build_dom_root(pTreeDom)
end
