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
require("router.procedures.constant")
require("ui.constant.path")
require("ui.run.load.interface.position")
require("ui.run.load.interface.worldmap")
require("utils.procedure.copy")
require("utils.procedure.directory")
require("utils.procedure.string")
require("utils.provider.xml.provider")
require("utils.struct.class")

local function load_image(sImgDirPath, sImgName)
    local pImgData = load_image_from_path(RWndPath.LOVE_IMAGE_DIR_PATH .. sImgDirPath .. "/" .. sImgName .. ".png")
    return love.graphics.newImage(pImgData)
end

CStockInventoryItem = createClass({
    pImgShd,
    tpImgs = {}
})

function CStockInventoryItem:load()
    self.pImgShd = load_image(RWndPath.INTF_INVT_WND, "shadow")
end

function CStockInventoryItem:_load_image_from_directory(pStockHeader, iId)
    local siType = pStockHeader:get_type(iId)

    local sImgFilePath = pStockHeader:get_image_path(iId)
    local rgsSplitPath = split_path(sImgFilePath)

    local sImgFileName = table.remove(rgsSplitPath)
    local sImgDirPath = table.concat(rgsSplitPath, "/")

    local pImg = load_image(sImgDirPath, sImgFileName)
    return pImg
end

function CStockInventoryItem:get_shadow()
    return self.pImgShd
end

function CStockInventoryItem:get_image_by_itemid(pStockHeader, iId)
    local m_tpImgs = self.tpImgs

    local pImg = m_tpImgs[iId]
    if pImg == nil then
        pImg = self:_load_image_from_directory(pStockHeader, iId)
        m_tpImgs[iId] = pImg
    end

    return pImg
end

CStockInventoryTab = createClass({
    rgpImgTabNames,
    tpImgTabQuads = {},
    pImgBgrd
})

local function load_tab_quad(tpImgTabQuads, sQuadName)
    tpImgTabQuads[sQuadName] = load_image(RWndPath.INTF_INVT_TAB, sQuadName)
end

function CStockInventoryTab:load()
    local m_tpImgTabQuads = self.tpImgTabQuads
    load_tab_quad(m_tpImgTabQuads, "fill0")
    load_tab_quad(m_tpImgTabQuads, "fill1")
    load_tab_quad(m_tpImgTabQuads, "left0")
    load_tab_quad(m_tpImgTabQuads, "left1")
    load_tab_quad(m_tpImgTabQuads, "middle0")
    load_tab_quad(m_tpImgTabQuads, "middle1")
    load_tab_quad(m_tpImgTabQuads, "middle2")
    load_tab_quad(m_tpImgTabQuads, "right0")
    load_tab_quad(m_tpImgTabQuads, "right1")

    self.pImgBgrd = load_image(RWndPath.INTF_INVT_WND, "backgrnd")

    self.rgpImgTabNames = {}
    local m_rgpImgTabNames = self.rgpImgTabNames

    local nImgs = 5
    for i = 0, nImgs - 1, 1 do
        local pImg = load_image(RWndPath.INTF_INVT_WND, "Tab.enabled." .. i)
        table.insert(m_rgpImgTabNames, pImg)
    end
end

function CStockInventoryTab:get_tab_components()
    return self.tpImgTabQuads
end

function CStockInventoryTab:get_tab_names()
    return self.rgpImgTabNames
end

function CStockInventoryTab:get_background()
    return self.pImgBgrd
end

CStockInventoryNumber = createClass({
    rgpNumImgs
})

function CStockInventoryNumber:load()
    self.rgpNumImgs = {}
    local m_rgpNumImgs = self.rgpNumImgs

    for i = 0, 9, 1 do
        local pImg = load_image(RWndPath.INTF_ITEM_NO, "ItemNo." .. i)
        table.insert(m_rgpNumImgs, pImg)
    end
end

function CStockInventoryNumber:get_image_by_number(iDigit)
    local m_rgpNumImgs = self.rgpNumImgs

    local pImg = m_rgpNumImgs[iDigit + 1]
    return pImg
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
    local tImgFiles = listdir(RWndPath.LOVE_IMAGE_DIR_PATH .. sImgDirPath, true)

    local tsItemPath = {}
    for sPath, _ in pairs(tImgFiles) do
        local iId = fetch_item_id_from_icon(sPath)
        if iId ~= nil then
            local sItemPath = string.sub(sPath, string.len(RWndPath.LOVE_IMAGE_DIR_PATH) + 1, -1 * (string.len(".png") + 1))
            tsItemPath[iId] = sItemPath
        end
    end

    return tsItemPath
end

local function read_item_headers(tpImgItemDirType)
    local tiItemType = {}
    for _, siType in pairs(tpImgItemDirType) do
        tiItemType[siType] = {}
    end

    local tsItemPath = {}
    for sDirPath, siType in pairs(tpImgItemDirType) do
        local tsDirItems = fetch_directory_itemids(sDirPath)

        local tItems = tiItemType[siType]
        for iId, _ in pairs(tsDirItems) do
            tItems[iId] = 1
        end

        table_merge(tsItemPath, tsDirItems)
    end

    return tiItemType, tsItemPath
end

CStockHeader = createClass({
    tpImgItemDirType,
    tiItemType,
    tsItemPath
})

local function load_item_directory_paths()
    local tpImgItemDirType = {}

    tpImgItemDirType["Character.wz/*"] = 1
    tpImgItemDirType["Item.wz/Consume"] = 2
    tpImgItemDirType["Item.wz/Install"] = 3
    tpImgItemDirType["Item.wz/Etc"] = 4
    tpImgItemDirType["Item.wz/Cash"] = 5

    return tpImgItemDirType
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

function CStockHeader:load()
    self.tpImgItemDirType = load_item_directory_paths()

    local tiTypeItem
    tiTypeItem, self.tsItemPath = read_item_headers(self.tpImgItemDirType)

    self.tiItemType = make_remissive_index_type_items(tiTypeItem)
end

function CStockHeader:get_type(iId)
    local siType = self.tiItemType[iId]
    return siType
end

function CStockHeader:get_image_path(iId)
    local sImgPath = self.tsItemPath[iId]
    return sImgPath
end

CStockInventory = createClass({
    pStockInvt = CStockInventoryItem:new(),
    pStockTab = CStockInventoryTab:new(),
    pStockCount = CStockInventoryNumber:new(),

    pStockHeader = CStockHeader:new()
})

function CStockInventory:load()
    self.pStockHeader:load()
    self.pStockInvt:load()
    self.pStockTab:load()
    self.pStockCount:load()
end

function CStockInventory:get_shadow()
    return self.pStockInvt:get_shadow()
end

function CStockInventory:get_image_by_itemid(iId)
    return self.pStockInvt:get_image_by_itemid(self.pStockHeader, iId)
end

function CStockInventory:get_tab_components()
    return self.pStockTab:get_tab_components()
end

function CStockInventory:get_tab_names()
    return self.pStockTab:get_tab_names()
end

function CStockInventory:get_background()
    return self.pStockTab:get_background()
end

function CStockInventory:get_images_by_number(iNum)
    local rgpNumImgs = {}

    if iNum ~= nil then
        local m_pCountStorage = self.pStockCount

        for _, i in ipairs(math.dlist(iNum)) do
            local pImg = m_pCountStorage:get_image_by_number(i)
            table.insert(rgpNumImgs, pImg)
        end
    end

    return rgpNumImgs
end

function load_image_stock_inventory()
    local ctVwInvt = CStockInventory:new()
    ctVwInvt:load()

    return ctVwInvt
end
