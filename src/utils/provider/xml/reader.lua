--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("utils.logger.file")
require("utils.provider.io.file")
--local xml2lua = require("xml2lua")
--local pXmlHandler = require("xmlhandler.dom")
require("provider.xml_dom")

local function pcall_parse_xml(sContent, sXmlPath)
    local bResult, oRet = pcall(
        function ()
            --[[
            local pXmlFileHandler = pXmlHandler:new()
            local pXmlParser = xml2lua.parser(pXmlFileHandler)

            pXmlParser:parse(sContent)
            return pXmlFileHandler.root
            ]]--

            local pContent = parse_xml_file(sXmlPath)
            return pContent
        end
    )

    if bResult then
        return oRet
    else
        log(LPath.FALLBACK, "io.txt", "[ERROR] Could not parse content from '" .. sXmlPath .. "'")
        return nil
    end
end

function read_xml_file(sDomXmlPath)
    local sContent = pcall_read_file(sDomXmlPath)
    local oRoot = pcall_parse_xml(sContent, sDomXmlPath)

    return oRoot
end
