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
require("utils.provider.xml.provider")
require("utils.struct.class")

local function load_image(sImgDirPath, sImgName)
    local pImgData = load_image_from_path(RWndPath.LOVE_IMAGE_DIR_PATH .. sImgDirPath .. "/" .. sImgName .. ".png")
    return love.graphics.newImage(pImgData)
end

CStockInventoryItem = createClass({
    rgsImgItemPath,
    pImgShd,
    tpImgs = {}
})

function CStockInventoryItem:load(rgsImgItemPath)
    self.rgsImgItemPath = rgsImgItemPath
    self.pImgShd = load_image(RWndPath.INTF_INVT_WND, "shadow")
end

function CStockInventoryItem:_load_image_from_directory(iId)
    local siType = iId / 1000000
    local m_rgsImgItemPath = self.rgsImgItemPath

    local sImgDirPath = m_rgsImgItemPath[siType]
    local pImg = load_image(sImgDirPath, "0" .. iId .. ".info.iconRaw")

    return pImg
end

function CStockInventoryItem:get_shadow()
    return self.pImgShd
end

function CStockInventoryItem:get_image_by_itemid(iId)
    local m_tpImgs = self.tpImgs

    local pImg = m_tpImgs[iId]
    if pImg == nil then
        pImg = self:_load_image_from_directory(iId)
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

function CStockInventoryTab:load(rgsImgItemPath)
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

    local nImgs = #rgsImgItemPath
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

CStockInventory = createClass({
    rgsImgItemPath = {"Item.wz/Equip", "Item.wz/Use", "Item.wz/Install", "Item.wz/Etc", "Item.wz/Cash"},

    pStockInvt = CStockInventoryItem:new(),
    pStockTab = CStockInventoryTab:new(),
    pStockCount = CStockInventoryNumber:new(),
})

function CStockInventory:load()
    local m_rgsImgItemPath = self.rgsImgItemPath

    self.pStockInvt:load(m_rgsImgItemPath)
    self.pStockTab:load(m_rgsImgItemPath)
    self.pStockCount:load()
end

function CStockInventory:get_shadow()
    return self.pStockInvt:get_shadow()
end

function CStockInventory:get_image_by_itemid(iId)
    return self.pStockInvt:get_image_by_itemid(iId)
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
