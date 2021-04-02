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

CInvtStorageItem = createClass({
    rgsImgItemPath,
    pImgShd,
    tpImgs = {}
})

function CInvtStorageItem:load(rgsImgItemPath)
    self.rgsImgItemPath = rgsImgItemPath
    self.pImgShd = load_image(RWndPath.INTF_INVT_WND, "shadow")
end

function CInvtStorageItem:_load_image_from_directory(iId)
    local siType = iId / 1000000
    local m_rgsImgItemPath = self.rgsImgItemPath

    local sImgDirPath = m_rgsImgItemPath[siType]
    local pImg = load_image(sImgDirPath, "0" .. iId .. ".info.iconRaw")

    return pImg
end

function CInvtStorageItem:get_shadow()
    return self.pImgShd
end

function CInvtStorageItem:get_image_by_itemid(iId)
    local m_tpImgs = self.tpImgs

    local pImg = m_tpImgs[iId]
    if pImg == nil then
        pImg = self:_load_image_from_directory(iId)
        m_tpImgs[iId] = pImg
    end

    return pImg
end

CInvtStorageTab = createClass({
    rgpImgTabNames,
    tpImgTabQuads = {},
    pImgBgrd
})

local function load_tab_quad(tpImgTabQuads, sQuadName)
    tpImgTabQuads[sQuadName] = load_image(RWndPath.INTF_INVT_TAB, sQuadName)
end

function CInvtStorageTab:load(rgsImgItemPath)
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

function CInvtStorageTab:get_tab_components()
    return self.tpImgTabQuads
end

function CInvtStorageTab:get_tab_names()
    return self.rgpImgTabNames
end

function CInvtStorageTab:get_background()
    return self.pImgBgrd
end

CInvtStorageNumber = createClass({
    rgpNumImgs
})

function CInvtStorageNumber:load()
    self.rgpNumImgs = {}
    local m_rgpNumImgs = self.rgpNumImgs

    for i = 0, 9, 1 do
        local pImg = load_image(RWndPath.INTF_ITEM_NO, "ItemNo." .. i)
        table.insert(m_rgpNumImgs, pImg)
    end
end

function CInvtStorageNumber:get_image_by_number(iDigit)
    local m_rgpNumImgs = self.rgpNumImgs

    local pImg = m_rgpNumImgs[iDigit + 1]
    return pImg
end

CInvtStorage = createClass({
    rgsImgItemPath = {"Item.wz/Equip", "Item.wz/Use", "Item.wz/Install", "Item.wz/Etc", "Item.wz/Cash"},

    pInvtStorage = CInvtStorageItem:new(),
    pTabStorage = CInvtStorageTab:new(),
    pCountStorage = CInvtStorageNumber:new(),
})

function CInvtStorage:load()
    local m_rgsImgItemPath = self.rgsImgItemPath

    self.pInvtStorage:load(m_rgsImgItemPath)
    self.pTabStorage:load(m_rgsImgItemPath)
    self.pCountStorage:load()
end

function CInvtStorage:get_shadow()
    return self.pInvtStorage:get_shadow()
end

function CInvtStorage:get_image_by_itemid(iId)
    return self.pInvtStorage:get_image_by_itemid(iId)
end

function CInvtStorage:get_tab_components()
    return self.pTabStorage:get_tab_components()
end

function CInvtStorage:get_tab_names()
    return self.pTabStorage:get_tab_names()
end

function CInvtStorage:get_background()
    return self.pTabStorage:get_background()
end

function CInvtStorage:get_images_by_number(iNum)
    local rgpNumImgs = {}

    if iNum ~= nil then
        local m_pCountStorage = self.pCountStorage

        for _, i in ipairs(math.dlist(iNum)) do
            local pImg = m_pCountStorage:get_image_by_number(i)
            table.insert(rgpNumImgs, pImg)
        end
    end

    return rgpNumImgs
end
