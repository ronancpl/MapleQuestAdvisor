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

CStockHeaderNpc = createClass({
    tEntries
})

local function load_image(sImgDirPath, sImgName)
    local pImgData = load_image_from_path(sImgDirPath .. "/" .. sImgName)
    return love.graphics.newImage(pImgData)
end

local function fetch_npc_id_from_stand(sNpcImgPath)
    if not string.ends_with(sNpcImgPath, "stand.0.png") then     -- selects default-img only
        return nil
    end

    local sImgPath = sNpcImgPath
    local iLen = string.len(".img/stand.0.png")

    local sNpcId = string.sub(sImgPath, -iLen-7, -iLen-1)
    return tonumber(sNpcId)
end

local function fetch_directory_itemids(sDirPath)
    local tImgFiles = list_dir_images_from_path(sDirPath)

    local tEntries = {}
    for sPath, _ in pairs(tImgFiles) do
        local iId = fetch_npc_id_from_stand(sPath)
        if iId ~= nil then
            tEntries[iId] = 1
        end
    end

    return tEntries
end

local function read_item_headers()
    local tEntries = fetch_directory_itemids("Npc.wz")
    return tEntries
end

function CStockHeaderNpc:load()
    self.tEntries = read_item_headers()
end

function CStockHeaderNpc:_get_image_path(iId)
    if self.tEntries[iId] == nil then
        return nil
    end

    local sImgPath = "Npc.wz/" .. tostring(iId) .. ".img/stand.0.png"
    return sImgPath
end

function CStockHeaderNpc:load_image_by_id(iId)
    local sImgFilePath = self:_get_image_path(iId) or self:_get_image_path(1013000)

    local pImg = nil
    if sImgFilePath ~= nil then
        local rgsSplitPath = split_path(sImgFilePath)

        local sStand = table.remove(rgsSplitPath)
        local sImgFileName = table.remove(rgsSplitPath)
        local sImgDirPath = table.concat(rgsSplitPath, "/")
        sImgFileName = sImgFileName .. "/" .. sStand

        pImg = load_image(sImgDirPath, sImgFileName)
    end

    return pImg
end
