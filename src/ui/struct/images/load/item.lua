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
    tiItemType,
    tsItemPath
})

local function load_image(sImgDirPath, sImgName)
    local pImgData = load_image_from_path(sImgDirPath .. "/" .. sImgName .. ".png")
    return love.graphics.newImage(pImgData)
end

local function load_item_directory_paths()
    local tpImgDirType = {}

    tpImgDirType["Character.wz/*"] = 1
    tpImgDirType["Item.wz/Consume"] = 2
    tpImgDirType["Item.wz/Install"] = 3
    tpImgDirType["Item.wz/Etc"] = 4
    tpImgDirType["Item.wz/Cash"] = 5

    return tpImgDirType
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
    local rgsSp = split_path(sImgPath)
    local bEquip = string.starts_with(rgsSp[#rgsSp], "info.")

    local iLen
    if bEquip then
        iLen = string.len(".img/info.iconRaw.png")
    else
        iLen = string.len(".info.iconRaw.png")
    end

    local sItemId = string.sub(sImgPath, -iLen-8, -iLen)
    return tonumber(sItemId)
end

local function fetch_directory_itemids(sDirPath)
    local rgsPath = split_path(sDirPath)
    if rgsPath[#rgsPath] == "*" then
        table.remove(rgsPath)
    end

    local sImgDirPath = table.concat(rgsPath, "/")
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
    self.tpImgDirType = load_item_directory_paths()

    local tiTypeItem
    tiTypeItem, self.tsItemPath = read_item_headers(self.tpImgDirType)

    self.tiItemType = make_remissive_index_type_items(tiTypeItem)
end

function CStockHeaderItem:get_type(iId)
    local siType = self.tiItemType[iId]
    return siType
end

function CStockHeaderItem:get_image_path(iId)
    local sImgPath = self.tsItemPath[iId]
    return sImgPath
end

function CStockHeaderItem:load_image_by_id(iId)
    local siType = self:get_type(iId)

    local sImgFilePath = self:get_image_path(iId)

    local pImg = nil
    if sImgFilePath ~= nil then
        local rgsSplitPath = split_path(sImgFilePath)

        local sImgFileName = table.remove(rgsSplitPath)
        local sImgDirPath = table.concat(rgsSplitPath, "/")

        pImg = load_image(sImgDirPath, sImgFileName)
    end

    return pImg
end
