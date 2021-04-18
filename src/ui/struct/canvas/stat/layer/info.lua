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
require("ui.struct.window.summary")
require("ui.struct.window.frame.layer")
require("utils.struct.class")

CStatNavText = createClass({CWndLayer, {
    pFont = love.graphics.newFont(RWndPath.LOVE_FONT_DIR_PATH .. "arial.ttf", 12)
}})

function CStatNavText:_build_element(pPropInvt)
    self:add_element(LChannel.STAT_INFO, pPropInvt)
end

function CStatNavText:_build_element(sText, iPx, iPy)
    local pPropText = CStatElemPlaintext:new()

    pPropText:load(sText, pFont, 100, iPx, iPy)
    pPropText:visible()

    self:add_element(LChannel.WMAP_PLAINTXT, pPropText)
end

function CStatNavText:build(pStatProp)
    self:reset()

    -- add layer elements (character)
    local pInfoChr = pStatProp:get_info_character()

    self:_build_element(pInfoChr:get_name(), 60, 33)
    self:_build_element(pInfoChr:get_job(), 60, 50)
    self:_build_element(pInfoChr:get_level(), 60, 78)
    self:_build_element("-", 60, 98)
    self:_build_element("-", 60, 118)
    self:_build_element("-", 60, 138)
    self:_build_element(pInfoChr:get_exp(), 60, 158)
    self:_build_element(pInfoChr:get_fame(), 60, 178)

    -- add layer elements (server)
    local pInfoSrv = pStatProp:get_info_server()

    self:_build_element(pInfoSrv:get_exp_rate(), 60, 245)
    self:_build_element(pInfoSrv:get_meso_rate(), 60, 265)
    self:_build_element(pInfoSrv:get_drop_rate(), 60, 285)
end
