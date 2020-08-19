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

local function SXmlProvider:split_path(sDomXmlPath)
    local str = sDomXmlPath .. '/'

    local asPathList = {}
    for w in str:gmatch("(.-)/") do
        table.insert(asPathList, w)
    end

    local sFile = table.remove(asPathList)
    return asPathList, sFile
end

local function SXmlProvider:access_xml_dir_node(pDomNode, sDirName)
    local pNextDomNode = pDomNode
    if pDomNode[sDirName] == nil then
        pNextDomNode = {}
        pDomNode[sDirName] = pNextDomNode
    end

    return pNextDomNode
end

local function SXmlProvider:access_xml_dir(asDirPath)
    local pDomNode = self.pDomTable

    for sDirName in asDirPath do
        pDomNode = access_xml_dir_node(pDomNode, sDirName)
    end

    return pDomNode
end

function SXmlProvider:load_xml(sPath)
    local asDirPath, sFileName = self.split_path(sPath)

    local pFileDom = read_xml_file(sPath)
    local pFileContent = parse_dom_file(pFileDom)

    local pDomNode = access_xml_dir(asDirPath)
    pDomNode[sFileName] = pFileContent

    return pFileContent
end

function SXmlProvider:unload_node(sPath)
    local asDirPath, sName = self.split_path(sPath)

    local pDomNode = access_xml_dir(asDirPath)
    pDomNode[sName] = nil
end

function SXmlProvider:enter_xml_dir(sDirPath)
    local asDirPath, sName = self.split_path(sDirPath .. '/')

    local pDomNode = access_xml_dir(asDirPath)
    return pDomNode
end
