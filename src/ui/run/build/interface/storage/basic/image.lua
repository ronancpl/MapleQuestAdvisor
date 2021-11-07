--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

local function fetch_repacker_path(sImgPath, sDirPath)
    local rgsSpPath = split_path(sImgPath)

    local i = #rgsSpPath
    while i > 0 do
        if string.ends_with(rgsSpPath[i], ".img") then
            break
        end

        i = i - 1
    end

    local sPrepend = ""
    if i > 0 then
        local rgsConcat = {}
        for j = i + 1, #rgsSpPath, 1 do
            table.insert(rgsConcat, rgsSpPath[j])
        end
        sPrepend = table.concat(rgsConcat, ".")

        local rgsImgPath = {}
        for j = 1, i, 1 do
            table.insert(rgsImgPath, rgsSpPath[j])
        end
        sImgPath = table.concat(rgsImgPath, "/")
    end

    return sImgPath, nil, sPrepend
end

function load_image_storage_from_wz_sub(sImgPath, sDirPath)
    local sPrepend
    sImgPath, sDirPath, sPrepend = fetch_repacker_path(sImgPath, sDirPath)

    local pDirImgs = load_images_from_path(sImgPath, sPrepend)
    return pDirImgs
end
