--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("utils/provider/xml/parser")
require("utils/provider/xml/reader")
require("utils/array")
require("utils/class")

SXmlProvider = createClass({pDomTable = {}})  -- table of XMLs

local function SXmlProvider:splitPath(sDomXmlPath)
    local str = sDomXmlPath .. '/'

    local asPathList = {}
    for w in str:gmatch("(.-)/") do
        table.insert(asPathList, w)
    end

    local sFile = table.remove(asPathList)
    return asPathList, sFile
end

local function SXmlProvider:accessXmlDirNode(pDomNode, sDirName)
    local pNextDomNode = pDomNode
    if pDomNode[sDirName] == nil then
        pNextDomNode = {}
        pDomNode[sDirName] = pNextDomNode
    end

    return pNextDomNode
end

local function SXmlProvider:accessXmlDir(asDirPath)
    local pDomNode = self.pDomTable

    for sDirName in asDirPath do
        pDomNode = accessXmlDirNode(pDomNode, sDirName)
    end

    return pDomNode
end

function SXmlProvider:loadXml(sPath)
    local asDirPath, sFileName = SXmlProvider:splitPath(sPath)

    local pFileDom = readXmlFile(sPath)
    local pFileContent = parseDomFile(pFileDom)

    local pDomNode = accessXmlDir(asDirPath)
    pDomNode[sFileName] = pFileContent
end

function SXmlProvider:unloadNode(sPath)
    local asDirPath, sName = SXmlProvider:splitPath(sPath)

    local pDomNode = accessXmlDir(asDirPath)
    pDomNode[sName] = nil
end
