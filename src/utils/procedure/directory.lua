--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

function scandir(sDirPath)
    local rgsFileNames = {}

    local sCurPath = io.popen"cd":read'*l'
    for sFileName in io.popen('dir "' .. sCurPath .. "\\..\\" .. sDirPath .. '" /b'):lines() do
        table.insert(rgsFileNames, sFileName)
    end

    return rgsFileNames
end

local function listrdir_recursive(sPath, sBasePath)
    local tpFiles = {}

    local pInfo = love.filesystem.getInfo(sPath)
    if pInfo ~= nil then
        local sInfoType = pInfo.type
        local sFilePath = sPath

        if sInfoType == "directory" then
            local sDirPath = sPath
            local rgsFiles = love.filesystem.getDirectoryItems(sDirPath)
            for _, sFileName in ipairs(rgsFiles) do
                local tpDirFiles = listrdir_recursive(sDirPath .. "/" .. sFileName, sBasePath)
                merge_table(tpFiles, tpDirFiles)
            end

            tpFiles[sFilePath] = 1
        elseif sInfoType == "file" then
            tpFiles[sFilePath] = 1
        end
    end

    return tpFiles
end

local function listdir_this(sPath)
    local tpFiles = {}

    local pInfo = love.filesystem.getInfo(sPath)
    if pInfo ~= nil then
        local sInfoType = pInfo.type
        local sFilePath = sPath

        if sInfoType == "directory" then
            tpFiles[sFilePath] = 1
        elseif sInfoType == "file" then
            tpFiles[sFilePath] = 1
        end
    end

    return tpFiles
end

function listdir(sPath, bRdir)
    if bRdir then
        return listrdir_recursive(sPath, "")
    else
        return listdir_this(sPath)
    end
end
