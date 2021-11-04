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
require("ui.constant.input")
require("ui.constant.path")
require("utils.procedure.copy")
require("utils.procedure.directory")
require("utils.procedure.string")

local function fetch_figure_subpath(sPath, sBasePath)
    local i = sPath:find(sBasePath)
    return sPath:sub(i+string.len(sBasePath)+1, -5)     -- remove file extension
end

local function fetch_pos_repacker_subrepeat(rgsSp)
    for i = 1, #rgsSp, 1 do
        if string.ends_with(rgsSp[i], ".img") then
            return i
        end
    end

    return -1
end

local function parse_repacker_path_repeater(sImgPath, iNumRepeats)
    local nSubRepeat = iNumRepeats

    local rgsSp = split_path(sImgPath)

    local rgsPathFound = {}

    local iIdxRep = fetch_pos_repacker_subrepeat(rgsSp)
    if iIdxRep > -1 then

        -- same path prefix until before ".img"
        for i = 1, iIdxRep -1, 1 do
            table.insert(rgsPathFound, rgsSp[i])
        end

        -- repeater
        for i = iIdxRep, #rgsSp - 1, 1 do
            for j = 1, nSubRepeat, 1 do
                table.insert(rgsPathFound, rgsSp[i])
            end
        end

        -- file name
        table.insert(rgsPathFound, rgsSp[#rgsSp])
    end

    return table.concat(rgsPathFound, "/")
end

local function parse_repacker_path_dot(sImgPath, bItc)
    local iIdx = sImgPath:rfind(".img")
    local sLpath = sImgPath:sub(1, iIdx + 3)

    local sRpath = sImgPath:sub(iIdx + 5)
    if bItc then    -- skip duplicate name from folder path
        local iIdx = string.find(sRpath, "/")
        sRpath = sRpath:sub(iIdx + 1)
    end

    sRpath = string.gsub(sRpath, "/", ".")

    return sLpath .. "/" .. sRpath
end

local function num_path_repeats(sImgPath)
    return (string.starts_with(sImgPath, "Character.wz") or string.starts_with(sImgPath, "Item.wz")) and 2 or 1
end

local function parse_repacker_path(sImgPath)
    sImgPath = parse_repacker_path_repeater(sImgPath, num_path_repeats(sImgPath))
    sImgPath = parse_repacker_path_dot(sImgPath, string.starts_with(sImgPath, "UI.wz/ITC.img"))
    return sImgPath
end

function fetch_repacker_img_path(sDirPath, sImgPath)
    local rgsPath = split_pathd(sImgPath)
    if #rgsPath > 0 then
        local sSubdirName = rgsPath[1]
        if string.ends_with(sDirPath, sSubdirName) then
            sDirPath = sDirPath:sub(1, -string.len(sSubdirName) - 2)
        end
    end

    return sDirPath .. "/" .. sImgPath
end

function load_image_from_path(sImgPath)
    local pImgData = love.image.newImageData(parse_repacker_path(RWndPath.LOVE_IMAGE_DIR_PATH .. sImgPath))
    return pImgData
end

function load_image_empty()
    local pImgData = love.image.newImageData(1, 1)
    return pImgData
end

local function extract_prefix_image_path(sPath)
    return string.sub(sPath, string.len(RWndPath.LOVE_IMAGE_DIR_PATH) + 1)
end

local function load_images_from_directory_path(sPath, sBasePath)
    local tpImgs = {}

    local pInfo = love.filesystem.getInfo(parse_repacker_path(sPath))
    if pInfo ~= nil then
        local sInfoType = pInfo.type
        if sInfoType == "directory" then
            local sDirPath = sPath
            local rgsFiles = love.filesystem.getDirectoryItems(parse_repacker_path(sDirPath))
            for _, sFileName in ipairs(rgsFiles) do
                local tpDirImgs = load_images_from_directory_path(sDirPath .. "/" .. sFileName, sBasePath)
                table_merge(tpImgs, tpDirImgs)
            end
        elseif sInfoType == "file" then
            if string.ends_with(sPath, ".png") then
                local sImgPath = sPath
                sImgPath = extract_prefix_image_path(sImgPath)

                local pImgData = load_image_from_path(sImgPath)
                local sImgSubpath = fetch_figure_subpath(sImgPath, sBasePath)

                tpImgs[sImgSubpath] = pImgData
            end
        end
    end

    return tpImgs
end

function load_images_from_path(sPath, sPrepend)
    local sBasePath = sPath
    local tpItems = load_images_from_directory_path(RWndPath.LOVE_IMAGE_DIR_PATH .. sPath, sBasePath)

    local pDirImages = CMediaTable:new()
    pDirImages:set_path(sBasePath)
    pDirImages:set_contents(tpItems)
    pDirImages:set_prepend(sPrepend)

    return pDirImages
end

local function is_image_file_path(sPath, rgsImgExts)
    local rgsImgExts = {"png"}
    for _, sImgExt in ipairs(rgsImgExts) do
        if string.ends_with(sPath, sImgExt) then
            return true
        end
    end

    return false
end

function list_dir_images_from_path(sPath)
    local tImgFiles = {}

    local tFiles = listdir(RWndPath.LOVE_IMAGE_DIR_PATH .. sPath, true)
    for sPath, pTok in pairs(tFiles) do
        if is_image_file_path(sPath, rgsImgExts) then
            local sImgKey = extract_prefix_image_path(sPath)
            tImgFiles[sImgKey] = pTok
        end
    end

    return tImgFiles
end
