--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("utils.provider.io.wordlist")
require("utils.struct.class")

CXmlNode = createClass({
    sName = "",
    sType = "",
    tChildren = {},
    tAttributes = {}
})

function CXmlNode:get(sAttr)
    return self.tAttributes[sAttr]
end

function CXmlNode:set(sAttr, sValue)
    self.tAttributes[sAttr] = sValue
end

function CXmlNode:get_name()
    return self.sName
end

function CXmlNode:get_name_tonumber()
    return tonumber(self.sName)
end

function CXmlNode:set_name(sName)
    self.sName = sName
end

function CXmlNode:get_value()
    return self:get("value")
end

function CXmlNode:get_type()
    return self.sType
end

function CXmlNode:set_type(sType)
    self.sType = sType
end

function CXmlNode:get_node_type()
    return self.sNodeType
end

function CXmlNode:set_node_type(sNodeType)
    self.sNodeType = sNodeType
end

function CXmlNode:add_child(pChild)
    local sName = pChild:get_name()
    self.tChildren[sName] = pChild
end

function CXmlNode:get_children()
    return self.tChildren
end

function CXmlNode:get_child_by_name(sPath)
    local rgsPath = split_path(sPath)

    local pRet = self.tChildren
    for _, sName in ipairs(rgsPath) do
        pRet = pRet[sName]
    end

    return pRet
end
