--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("composer.field.node.media.image")
require("ui.constant.path")
require("utils.provider.io.wordlist")
require("utils.struct.class")

CStockHeaderItem = createClass({
    tpImgDirType,
    tItemTypeDir,
    tiItemType,
    tsItemPath
})

local function load_image(sImgDirPath, sImgName)
    local pImgData = load_image_from_path(sImgDirPath, "/" .. sImgName .. ".png")
    return love.graphics.newImage(pImgData)
end

local function load_item_directory_paths()
    local tpImgDirType = {}

    tpImgDirType["Character.wz/*"] = 1
    tpImgDirType["Item.wz/Consume"] = 2
    tpImgDirType["Item.wz/Install"] = 3
    tpImgDirType["Item.wz/Etc"] = 4
    tpImgDirType["Item.wz/Cash"] = 5

    local tItemTypeDir = {}
    tItemTypeDir[2] = "Consume"
    tItemTypeDir[3] = "Install"
    tItemTypeDir[4] = "Etc"
    tItemTypeDir[5] = "Cash"

    return tpImgDirType, tItemTypeDir
end

local function make_remissive_index_type_items(tTypeItems)
    local tiItemType = {}
    for siIvtType, tItems in pairs(tTypeItems) do
        for iId, _ in pairs(tItems) do
            tiItemType[iId] = siIvtType
        end
    end

    return tiItemType
end

local function fetch_item_id_from_icon(sFilePath)
    if not string.ends_with(sFilePath, ".iconRaw.png") then     -- selects icon-file only
        return nil
    end

    local sImgPath = sFilePath
    local bEquip = string.starts_with(string.sub(sImgPath, -17), "/info.")

    local iLen
    if bEquip then
        iLen = string.len(".img/info.iconRaw.png")
    else
        iLen = string.len(".info.iconRaw.png")
    end

    local sItemId = string.sub(sImgPath, -iLen-8, -iLen-1)
    return tonumber(sItemId)
end

local function fetch_directory_itemids(sDirPath)
    local sImgDirPath

    local iIdx = string.rfind(sDirPath, "/")
    local sFile = string.sub(sDirPath, iIdx + 1, iIdx + 1)
    if string.find(sFile, "%*") then
        sImgDirPath = string.sub(sDirPath, 0, iIdx - 1)
    else
        sImgDirPath = sDirPath
    end

    local tImgFiles = list_dir_images_from_path(sImgDirPath)

    local tsItemPath = {}
    for sPath, _ in pairs(tImgFiles) do
        local iId = fetch_item_id_from_icon(sPath)
        if iId ~= nil then
            local sItemPath = string.sub(sPath, 0, -1 * (string.len(".png") + 1))
            tsItemPath[iId] = sItemPath
        end
    end

    return tsItemPath
end

local function read_item_headers(tpImgDirType)
    local tiItemType = {}
    for _, siType in pairs(tpImgDirType) do
        tiItemType[siType] = {}
    end

    local tsItemPath = {}
    for sDirPath, siType in pairs(tpImgDirType) do
        local tsDirItems = fetch_directory_itemids(sDirPath)

        local tItems = tiItemType[siType]
        for iId, _ in pairs(tsDirItems) do
            tItems[iId] = 1
        end

        table_merge(tsItemPath, tsDirItems)
    end

    return tiItemType, tsItemPath
end

function CStockHeaderItem:load()
    self.tpImgDirType, self.tItemTypeDir = load_item_directory_paths()

    --[[local tiTypeItem
    tiTypeItem, self.tsItemPath = read_item_headers(self.tpImgDirType)

    self.tiItemType = make_remissive_index_type_items(tiTypeItem)
    ]]--
end

function CStockHeaderItem:get_type(iId)
    local siType = self.tiItemType[iId]
    return siType
end

function CStockHeaderItem:get_image_path(iId)
    local sImgPath
    local siType = math.floor(iId / 1000000)
    if siType ~= 1 then
        sImgPath = "Item.wz/" .. self.tItemTypeDir[siType]
        while string.ends_with(sImgPath, "*") do
            sImgPath = sImgPath:sub(0, string.rfind(sImgPath, "/"))
        end
        sImgPath = sImgPath .. "/" .. string.pad_number(math.floor(iId / 10000), 4) .. ".img/"
        sImgPath = sImgPath .. string.pad_number(math.floor(iId), 8) .. ".info.iconRaw"
    else
        sImgPath = "Character.wz/"

        if ((iId >= 1010000 and iId < 1040000) or (iId >= 1122000 and iId < 1123000) or (iId >= 1132000 and iId < 1133000) or (iId >= 1142000 and iId < 1143000)) then
            sImgPath = sImgPath .. "Accessory"
        elseif (iId >= 1000000 and iId < 1010000) then
            sImgPath = sImgPath .. "Cap"
        elseif (iId >= 1102000 and iId < 1103000) then
            sImgPath = sImgPath .. "Cape"
        elseif (iId >= 1040000 and iId < 1050000) then
            sImgPath = sImgPath .. "Coat"
        elseif (iId >= 20000 and iId < 22000) then
            sImgPath = sImgPath .. "Face"
        elseif (iId >= 1080000 and iId < 1090000) then
            sImgPath = sImgPath .. "Glove"
        elseif (iId >= 30000 and iId < 35000) then
            sImgPath = sImgPath .. "Hair"
        elseif (iId >= 1050000 and iId < 1060000) then
            sImgPath = sImgPath .. "Longcoat"
        elseif (iId >= 1060000 and iId < 1070000) then
            sImgPath = sImgPath .. "Pants"
        elseif (iId >= 1802000 and iId < 1842000) then
            sImgPath = sImgPath .. "PetEquip"
        elseif (iId >= 1112000 and iId < 1120000) then
            sImgPath = sImgPath .. "Ring"
        elseif (iId >= 1092000 and iId < 1100000) then
            sImgPath = sImgPath .. "Shield"
        elseif (iId >= 1070000 and iId < 1080000) then
            sImgPath = sImgPath .. "Shoes"
        elseif (iId >= 1900000 and iId < 2000000) then
            sImgPath = sImgPath .. "Taming"
        elseif (iId >= 1300000 and iId < 1800000) then
            sImgPath = sImgPath .. "Weapon"
        else
            sImgPath = sImgPath .. "*"
        end

        sImgPath = sImgPath .. "/" .. string.pad_number(iId, 8) .. ".img/info.iconRaw"
    end

    local pInfo = love.filesystem.getInfo(RWndPath.LOVE_IMAGE_DIR_PATH .. parse_repacker_path_internal(sImgPath) .. ".png")
    return pInfo and sImgPath or nil
end

function CStockHeaderItem:load_image_by_id(iId)
    local sImgFilePath = self:get_image_path(iId) or self:get_image_path(3010000)

    local pImg = nil
    if sImgFilePath ~= nil then
        local rgsSplitPath = split_path(sImgFilePath)

        local sImgFileName = table.remove(rgsSplitPath)
        local sImgDirPath = table.concat(rgsSplitPath, "/")

        pImg = load_image(sImgDirPath, sImgFileName)
    end

    return pImg
end
