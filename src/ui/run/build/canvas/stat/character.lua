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

CCharInfoTable = createClass({
    sName,
    siJob,
    siLevel,
    sGuildName = nil,
    iHp = nil,
    iMp = nil,
    iExp,
    siFame
})

function CCharInfoTable:get_name()
    return self.sName
end

function CCharInfoTable:set_name(sName)
    self.sName = sName
end

function CCharInfoTable:get_job()
    return self.siJob
end

function CCharInfoTable:set_job(siJob)
    self.siJob = siJob
end

function CCharInfoTable:get_level()
    return self.siLevel
end

function CCharInfoTable:set_level(siLevel)
    self.siLevel = siLevel
end

function CCharInfoTable:get_exp()
    return self.iExp
end

function CCharInfoTable:set_exp(iExp)
    self.iExp = iExp
end

function CCharInfoTable:get_fame()
    return self.siFame
end

function CCharInfoTable:set_fame(siFame)
    self.siFame = siFame
end
