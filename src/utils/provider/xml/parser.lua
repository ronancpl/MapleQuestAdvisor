--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

local function parseDomNodeChilds(pNodeChilds, pTreeNode)
    pN = table.remove(pNodeChilds)  -- avoid handling child N

    for _, pChildFileNode in pairs(pNodeChilds) do
        pChildTreeNode = parseDomNode(pChildFileNode)
        table.insert(pTreeNode, pChildTreeNode)
    end

    table.insert(pNodeChilds, pN)   -- adds back child N
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

local function parseDomNodeAttribute(pTreeNode)
    local sDataType = pTreeNode["_name"]
    local tAttr = pTreeNode["_attr"]

    local sName = pAttr["name"]
    local sValue = pAttr["value"]

    local uValue = parseDomDataAttribute(sDataType, sValue)
    pTreeNode["_value"] = uValue
end

local function parseDomNode(pFileNode)
    pTreeNode = {}

    pTreeNode["_type"] = pFileNode["_type"]
    pTreeNode["_name"] = pFileNode["_name"]

    pTreeNode["_attr"] = pFileNode["_attr"]
    parseDomNodeAttribute(pTreeNode)

    pTreeNode["_children"] = {}
    tChildren = pFileNode["_children"]

    parseDomNodeChilds(tChildren, pTreeNode["_children"])

    return pTreeNode
end

function parseDomFile(pFileDom)
    pTreeDom = parseDomNode(pFileDom)
    return pTreeDom
end
