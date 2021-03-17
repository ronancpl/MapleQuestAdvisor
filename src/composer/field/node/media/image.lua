--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("composer.field.node.media.storage.storage")
require("ui.constant.path")
require("utils.procedure.string")
require("utils.procedure.unpack")
require("utils.provider.io.wordlist")

local function fetch_figure_subpath(sPath, sBasePath)
    local i = sPath:find(sBasePath)
    return sPath:sub(i+string.len(sBasePath)+1, -5)     -- remove file extension
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

                local pImgData = love.image.newImageData(sImgPath)
                local sImgSubpath = fetch_figure_subpath(sImgPath, sBasePath)
                tpImgs[sImgSubpath] = pImgData
            end
        end
    end

    return tpImgs
end

function load_images_from_path(sPath)
    local sBasePath = sPath
    local tpItems = load_images_from_directory_path(RWndPath.LOVE_IMAGE_DIR_PATH .. sPath, sBasePath)

    local pDirImages = CMediaTable:new()
    pDirImages:set_path(sBasePath)
    pDirImages:set_contents(tpItems)

    return pDirImages
end
