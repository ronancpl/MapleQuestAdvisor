--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("utils.struct.class")

CImageSelectBox = createClass({
    pImgL,
    pImgC,
    pImgR
})

function CImageSelectBox:get_left()
    return self.pImgL
end

function CImageSelectBox:get_center()
    return self.pImgC
end

function CImageSelectBox:get_right()
    return self.pImgR
end

local function make_image_bar(pDirSliderImgs, sImgName)
    local pImgDataBar = find_image_on_storage(pDirSliderImgs, sImgName)

    local pImgBar = pImgDataBar ~= nil and love.graphics.newImage(pImgDataBar) or nil
    return pImgBar
end

local function load_texture_family(pDirSliderImgs, sImgPath, sImgFamily, rgpImgs)
    clear_table(rgpImgs)

    local sImgFamPath = sImgPath .. "." .. sImgFamily

    local pImg = make_image_bar(pDirSliderImgs, sImgFamPath)
    if pImg == nil then
        local i = 0
        while true do
            pImg = make_image_bar(pDirSliderImgs, sImgFamPath .. tostring(i))
            if pImg == nil then
                break
            end

            table.insert(rgpImgs, pImg)
            i = i + 1
        end
    else
        table.insert(rgpImgs, pImg)
    end
end

function CImageSelectBox:load_texture_set(pDirSliderImgs, sTextureSet, sImgFamily)
    local rgpImgs = {}
    load_texture_family(pDirSliderImgs, sTextureSet, sImgFamily .. ".", rgpImgs)

    self.pImgL = rgpImgs[1]
    self.pImgC = rgpImgs[2]
    self.pImgR = rgpImgs[3]
end
