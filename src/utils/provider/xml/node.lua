--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require "utils/class";

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

function CXmlNode:getName()
    return self.sName
end

function CXmlNode:setName(sName)
    self.sName = sName
end

function CXmlNode:getType()
    return self.sType
end

function CXmlNode:setType(sType)
    self.sType = sType
end

function CXmlNode:addChild(pChild)
    table.insert(self.tChildren, pChild)
end

function CXmlNode:getChildren()
    return self.tChildren
end
