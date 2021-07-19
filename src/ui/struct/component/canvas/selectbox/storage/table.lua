--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

CStockSelectBox = createClass({
    pImgL,
    pImgC,
    pImgR
})

function CStockSelectBox:load(pImgL, pImgC, pImgR)
    self.pImgL = pImgL
    self.pImgC = pImgC
    self.pImgR = pImgR
end

function CStockSelectBox:get_center()
    return self.pImgC
end

function CStockSelectBox:get_left()
    return self.pImgL
end

function CStockSelectBox:get_right()
    return self.pImgR
end
