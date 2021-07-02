--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("ui.constant.path")
require("utils.struct.class")

CStyleText = createClass({
    sTitle,
    pFontTitle,
    pTxtTitle,

    sDesc,
    pFontDesc,
    pTxtDesc,

    sTitleFont,
    iTitleSz,
    sDescFont,
    iDescSz
})

function CStyleText:load_font(sTitleFont, iTitleSz, sDescFont, iDescSz)
    self.sTitleFont = RWndPath.LOVE_FONT_DIR_PATH .. sTitleFont
    self.iTitleSz = iTitleSz

    self.sDescFont = RWndPath.LOVE_FONT_DIR_PATH .. sDescFont
    self.iDescSz = iDescSz

    self.pFontTitle = ctPoolFont:take_font(self.sTitleFont, iTitleSz)
    self.pFontDesc = ctPoolFont:take_font(self.sDescFont, iDescSz)
end

function CStyleText:update_text(sTitle, sDesc)
    self.sTitle = sTitle
    self.sDesc = sDesc
end

function CStyleText:update_format(pTxtTitle, pTxtDesc)
    self.pTxtTitle = pTxtTitle
    self.pTxtDesc = pTxtDesc
end

function CStyleText:get_font()
    return self.pFontTitle, self.pFontDesc
end

function CStyleText:get_text()
    return self.sTitle, self.sDesc
end

function CStyleText:get_drawable()
    return self.pTxtTitle, self.pTxtDesc
end

function CStyleText:free()
    ctPoolFont:put_font(self.pFontTitle, self.sTitleFont, self.iTitleSz)
    ctPoolFont:put_font(self.pFontDesc, self.sDescFont, self.iDescSz)
end
