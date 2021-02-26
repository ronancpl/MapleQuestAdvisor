--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("utils.procedure.string")
require("utils.procedure.unpack")
require("utils.provider.io.wordlist")

function load_images_from_path(sPath)
    local tpImgs = {}

    local pInfo = love.filesystem.get_info(sPath)
    if pInfo ~= nil then
        local sInfoType = pInfo.type
        if sInfoType == "directory" then
            local sDirPath = sPath
            local rgsFiles = love.filesystem.getDirectoryItems(sDirPath)
            for _, sFileName in ipairs(rgsFiles) do
                local tpDirImgs = load_images_from_path(sDirPath .. "/" .. sFileName)
                merge_table(tpImgs, tpDirImgs)
            end
        elseif sInfoType == "file" then
            if string.ends_with(sPath, ".png") then
                local sImgPath = sPath
                log_st(LPath.INTERFACE, "_locator.txt", "IMG AS '" .. sImgPath .. "'")

                local pImg = love.graphics.newImage(sImgPath)
                tpImgs[sImgPath] = pImg
            end
        end
    end

    return tpImgs
end

function load_images_from_wz_sub(sDirPath)
    local tpImgs = load_images_from_path(sDirPath)
    return tpImgs
end

function fetch_image_from_container(tpImgs, sPath)
    return tpImgs[sPath]
end
