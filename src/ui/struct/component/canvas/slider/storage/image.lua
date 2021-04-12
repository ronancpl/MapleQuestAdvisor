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

CImageSlider = createClass({
    pImgBase,
    rgpImgNext = {},
    rgpImgPrev = {},
    rgpImgThumb = {}
})

function CImageSlider:get_base()
    return self.pImgBase
end

function CImageSlider:get_next(siType)
    return self.rgpImgNext[siType]
end

function CImageSlider:get_prev(siType)
    return self.rgpImgPrev[siType]
end

function CImageSlider:get_thumb(siType)
    return self.rgpImgThumb[siType]
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

function CImageSlider:load_texture_set(pDirSliderImgs, sTextureSet)
    local rgpImgs = {}
    load_texture_family(pDirSliderImgs, sTextureSet, "base", rgpImgs)
    self.pImgBase = rgpImgs[1]

    load_texture_family(pDirSliderImgs, sTextureSet, "next", self.rgpImgNext)
    load_texture_family(pDirSliderImgs, sTextureSet, "prev", self.rgpImgPrev)
    load_texture_family(pDirSliderImgs, sTextureSet, "thumb", self.rgpImgThumb)
end
