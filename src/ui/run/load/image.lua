--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("utils.procedure.unpack")
require("utils.provider.io.wordlist")

function load_images_from_directory(sDirPath)
    local tpImgs = {}

    local rgsFiles = love.filesystem.getDirectoryItems(sDirPath)
    for _, sFileName in ipairs(rgsFiles) do
        local tImgPath = tpImgs

        local rgsText = split_text(sText)
        local nText = #rgsText
        if nText > 0 then
            for i = 1, nText - 1, 1 do  -- minus file extension
                tImgPath = create_inner_table_if_not_exists(tImgPath, rgsText[i])
            end

            local pImg = love.graphics.newImage(sDirPath .. sFileName)
            tImgPath["img"] = pImg
        end
    end

    return tpImgs
end

function load_images_from_wz_sub(sDirPath)
    local tpImgs = load_images_from_directory(sDirPath)
    return tpImgs
end
