--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

local function get_system_directory_path(sFileDir)
    return "..\\\\" .. sFileDir:gsub("%s", ""):gsub("[%,%?%!%:%;%@%[%]%_%{%}%~%/]", "\\\\")
end

local function get_directory_path(sPath)
    local iIdx = (sPath:reverse()):find("/")
    return (sPath:sub(1, -iIdx-1))
end

function create_directory_if_not_exists(sPath)
    local sFileDir = get_directory_path(sPath)

    local sSysPath = get_system_directory_path(sFileDir)
    local iResp = os.execute("cd " .. sSysPath .. "")
    if iResp == 1 then   -- path not exists
        iResp = os.execute("mkdir " .. sSysPath)
        if iResp ~= 0 then
            error(iResp)
        end

        os.execute("cd " .. sSysPath)
    end

    return sSysPath
end
