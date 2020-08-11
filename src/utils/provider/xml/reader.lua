--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

local xml2lua = require("xml2lua")
local pXmlHandler = require("xmlhandler.dom")
local pXmlParser = xml2lua.parser(pXmlHandler)

local function pcallReadFile(sFilePath)
    local bResult, oRet = pcall(
        function ()
            local osFile = assert( io.open(sFilePath, "rb") )
            sContent = osFile:read("*a")
            f:close()

            return sContent
        end
    )

    if bResult then
        return oRet
    else then
        print("[ERROR] Could not access file " .. sFilePath)
        return ""
    end

end

local function pcallParseXml(sContent)
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

function readXmlFile(sDomXmlPath)
    local sContent = readFile(sDomXmlPath)
    oRoot = pcallParseXml(sContent)

    return oRoot
end
