--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("utils.struct.array")
require("utils.struct.class")
require("utils.provider.xml.parser")
require("utils.provider.xml.reader")

SXmlProvider = createClass({pDomTable = {}})  -- table of XMLs

function SXmlProvider:_split_path(sDomXmlPath)
    local str = sDomXmlPath .. '/'

    local asPathList = {}
    for w in str:gmatch("(.-)/") do
        table.insert(asPathList, w)
    end

    local sFile = table.remove(asPathList)
    return asPathList, sFile
end

function SXmlProvider:_access_xml_dir_node(pDomNode, sDirName)
    local pNextDomNode = pDomNode[sDirName]
    if pNextDomNode == nil then
        pNextDomNode = {}
        pDomNode[sDirName] = pNextDomNode
    end

    return pNextDomNode
end

function SXmlProvider:_access_xml_dir(asDirPath)
    local pDomNode = self.pDomTable

    for _, sDirName in ipairs(asDirPath) do
        pDomNode = self:_access_xml_dir_node(pDomNode, sDirName)
    end

    return pDomNode
end

function SXmlProvider:load_xml(sPath)
    local asDirPath, sFileName = self:_split_path(sPath)

    local pFileDom = read_xml_file(sPath)
    local pFileContent = parse_dom_file(pFileDom)

    local pDomNode = self:_access_xml_dir(asDirPath)
    pDomNode[sFileName] = pFileContent

    return pFileContent
end

function SXmlProvider:unload_node(sPath)
    local asDirPath, sName = self:_split_path(sPath)

    local pDomNode = self:_access_xml_dir(asDirPath)
    pDomNode[sName] = nil
end

function SXmlProvider:enter_xml_dir(sDirPath)
    local asDirPath, sName = self:_split_path(sDirPath .. '/')

    local pDomNode = self:_access_xml_dir(asDirPath)
    return pDomNode
end
