--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("utils.logger.file")

function pcall_read_file(sFilePath)
    local bResult, oRet = pcall(
        function ()
            local sFileSrcPath = "../" .. sFilePath
            local osFile = assert( io.open(sFileSrcPath, "rb") )
            local sContent = osFile:read("*a")
            osFile:close()

            return sContent
        end
    )

    if bResult then
        return oRet
    else
        log(LPath.FALLBACK, "io.txt", "[ERROR] Could not access file " .. sFilePath)
        return ""
    end

end
