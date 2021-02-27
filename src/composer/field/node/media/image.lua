--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("ui.path.path")
require("utils.procedure.string")
require("utils.procedure.unpack")
require("utils.provider.io.wordlist")

local function fetch_figure_subpath(sPath, sBasePath)
    local i = sPath:find(sBasePath)
    return sPath:sub(i+string.len(sBasePath)+1, -1)
end

local function load_images_from_directory_path(sPath, sBasePath)
    local tpImgs = {}

    local pInfo = love.filesystem.getInfo(sPath)
    if pInfo ~= nil then
        local sInfoType = pInfo.type
        if sInfoType == "directory" then
            local sDirPath = sPath
            local rgsFiles = love.filesystem.getDirectoryItems(sDirPath)
            for _, sFileName in ipairs(rgsFiles) do
                local tpDirImgs = load_images_from_directory_path(sDirPath .. "/" .. sFileName, sBasePath)
                merge_table(tpImgs, tpDirImgs)
            end
        elseif sInfoType == "file" then
            if string.ends_with(sPath, ".png") then
                local sImgPath = sPath

                local pImg = love.graphics.newImage(sImgPath)
                log_st(LPath.INTERFACE, "_locator.txt", "IMG AS '" .. sImgPath .. "' " .. tostring(pImg ~= nil))

                local sImgSubpath = fetch_figure_subpath(sImgPath, sBasePath)
                tpImgs[sImgSubpath] = pImg
            end
        end
    end

    return tpImgs
end

function load_images_from_path(sPath)
    return load_images_from_directory_path(RInterface.LOVE_IMAGE_DIR_PATH .. sPath, sPath)
end
