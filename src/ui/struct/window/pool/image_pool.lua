--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("ui.run.build.interface.storage.split")
require("ui.run.build.interface.storage.basic.image")
require("utils.struct.class")
require("utils.struct.pool")

local bit = require("bit")

CPoolImage = createClass({

    pPool = CPool:new()

})

local function get_key_table_image(sImgDir, sImgName)
    return sImgDir .. "/" .. sImgName
end

local function fn_create_item(sImgDir, sImgName)
    local pDirImgs = load_image_storage_from_wz_sub(RWndPath.INTF_UI_WND, sImgDir)
    pDirImgs = select_images_from_storage(pDirImgs, {})

    local pImgBase = love.graphics.newImage(find_image_on_storage(pDirImgs, sImgName))
    return pImgBase
end

function CPoolImage:init()
    self.pPool:load(get_key_table_image, fn_create_item)
end

function CPoolImage:take_image(sImgDir, sImgName)
    local m_pPool = self.pPool
    return m_pPool:take_object({sImgDir, sImgName})
end

function CPoolImage:put_image(pImg, sImgDir, sImgName)
    local m_pPool = self.pPool
    m_pPool:put_object(pImg, {sImgDir, sImgName})
end
