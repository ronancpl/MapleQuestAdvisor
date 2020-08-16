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

local function parseDomNodeChilds(pTreeNode, tFileNodeChilds)
    pN = table.remove(tFileNodeChilds)  -- avoid handling child N

    for _, pChildFileNode in pairs(tFileNodeChilds) do
        pChildTreeNode = parseDomNode(pChildFileNode)
        pTreeNode:addChild(pChildTreeNode)
    end

    table.insert(tFileNodeChilds, pN)   -- adds back child N
end

local tfn_ParseAttr = {
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

local function parseDomDataAttribute(sName, sValue)
    fn_dataAttr = tfn_ParseAttr[sName]
    if fn_dataAttr ~= nil then
        return fn_dataAttr(sValue)
    else
        return nil
    end
end

local function parseDomNodeAttributes(pTreeNode, tFileNodeAttrs)
    local sDataType = pTreeNode:getName()
    -- local tAttr = pTreeNode:getAttr()

    local sName = tFileNodeAttrs["name"]
    local sValue = tFileNodeAttrs["value"]

    local uValue = parseDomDataAttribute(sDataType, sValue)
    pTreeNode:set("name", sName)
    pTreeNode:set("value", uValue)
end

local function parseDomNode(pFileNode)
    pTreeNode = CXmlNode:new()

    pTreeNode:setType(pFileNode["_type"])
    pTreeNode:setName(pFileNode["_name"])

    parseDomNodeAttributes(pTreeNode, pFileNode["_attr"])
    parseDomNodeChilds(pTreeNode, pFileNode["_children"])

    return pTreeNode
end

function parseDomFile(pFileDom)
    pTreeDom = parseDomNode(pFileDom)
    return pTreeDom
end
