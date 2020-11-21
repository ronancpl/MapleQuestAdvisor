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

local function create_directory_path_advance(sPath)
    local iResp = os.execute("cd " .. sPath)
    if iResp == 1 then
        iResp = os.execute("mkdir " .. sPath)
        if iResp ~= 0 then
            error(iResp)
        end

        os.execute("cd " .. sPath)
    end
end

local function create_directory_path_return()
    os.execute("cd ..")
end

local create_directory_path_split(sPath)
    local rgsPathItems = sPath:split("/")

    for _, sPathItem in ipairs(rgsPathItems) do
        create_directory_path_advance(sPathItem)
    end

    for _, sPathItem in ipairs(rgsPathItems) do
        create_directory_path_return()
    end
end

local function get_system_directory_path(sFileDir)
    return sFileDir:gsub(" ", ""):gsub("%p", "/")
end

local function create_directory_if_not_exists(sPath)
    local iResp = os.execute("cd '" .. sPath .. "'")
    if iResp == 1 then   -- path not exists
        sPath = get_system_directory_path(sPath)
        create_directory_path_split(sPath)
    end

    return sPath
end

function pcall_log(sPath)
    local bResult, oRet = pcall(
        function ()
            return create_directory_if_not_exists(sPath)
        end
    )

    if bResult then
        return oRet
    else
        log(LPath.FALLBACK, "io.txt", "[ERROR] Could not access path '" .. sPath .. "'")
        return ""
    end
end
