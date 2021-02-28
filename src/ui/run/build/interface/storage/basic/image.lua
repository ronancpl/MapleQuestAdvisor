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

function load_image_storage_from_wz_sub(sImgPath, sDirPath)
    local sImgDirPath = sImgPath
    if sDirPath ~= nil then
        sImgDirPath = sImgDirPath .. "/" .. sDirPath
    end

    local tpImgs = load_images_from_path(sImgDirPath)
    return tpImgs
end