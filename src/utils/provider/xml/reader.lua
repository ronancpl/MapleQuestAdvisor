--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("utils/io/file")
local xml2lua = require("xml2lua")
local pXmlHandler = require("xmlhandler.dom")
local pXmlParser = xml2lua.parser(pXmlHandler)

local function pcall_parse_xml(sContent)
    local bResult, oRet = pcall(
        function ()
            pXmlParser:parse(sContent)
            return handler.root
        end
    )

    if bResult then
        return oRet
    else:
        print("[ERROR] Could not parse content " .. sContent)
        return nil
    end
end

function read_xml_file(sDomXmlPath)
    local sContent = pcall_read_file(sDomXmlPath)
    local oRoot = pcall_parse_xml(sContent)

    return oRoot
end
