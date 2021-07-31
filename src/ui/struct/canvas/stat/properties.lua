--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("ui.run.build.canvas.stat.character")
require("ui.run.build.canvas.stat.server")
require("utils.struct.class")

CStatProperties = createClass({
    pBaseImg,
    pInfoChr = CCharInfoTable:new(),
    pInfoSrv = CServerInfoTable:new()
})

function CStatProperties:reset()
    self.pBaseImg = nil
end

function CStatProperties:set_base_img(pBaseImg)
    self.pBaseImg = pBaseImg
end

function CStatProperties:get_base_img()
    return self.pBaseImg
end

function CStatProperties:_set_info_character(pPlayer)
    local m_pInfoChr = self.pInfoChr

    m_pInfoChr:set_name(pPlayer:get_name())
    m_pInfoChr:set_job(pPlayer:get_job_name())
    m_pInfoChr:set_level(pPlayer:get_level())
    m_pInfoChr:set_exp(pPlayer:get_exp())
    m_pInfoChr:set_fame(pPlayer:get_fame())
end

function CStatProperties:get_info_character()
    return self.pInfoChr
end

function CStatProperties:_set_info_server(siExpR, siMesoR, siDropR)
    local m_pInfoSrv = self.pInfoSrv

    m_pInfoSrv:set_exp_rate(siExpR)
    m_pInfoSrv:set_meso_rate(siMesoR)
    m_pInfoSrv:set_drop_rate(siDropR)
end

function CStatProperties:get_info_server()
    return self.pInfoSrv
end

function CStatProperties:update_stats(pPlayer, siExpR, siMesoR, siDropR)
    self:_set_info_character(pPlayer)
    self:_set_info_server(siExpR, siMesoR, siDropR)
end
