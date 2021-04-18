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

CServerInfoTable = createClass({
    siExpRate,
    siMesoRate,
    siDropRate
})

function CServerInfoTable:get_exp_rate()
    return self.siExpRate
end

function CServerInfoTable:set_exp_rate(siExpRate)
    self.siExpRate = siExpRate
end

function CServerInfoTable:get_meso_rate()
    return self.siMesoRate
end

function CServerInfoTable:set_meso_rate(siMesoRate)
    self.siMesoRate = siMesoRate
end

function CServerInfoTable:get_drop_rate()
    return self.siDropRate
end

function CServerInfoTable:set_drop_rate(siDropRate)
    self.siDropRate = siDropRate
end
