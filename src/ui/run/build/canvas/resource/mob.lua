--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("composer.containers.units.mob_group_table")
require("utils.procedure.copy")
require("utils.struct.class")

CRscMobTable = createClass({
    tiMobs = {}
})

function CRscMobTable:get_mobs()
    return self.tiMobs
end

function CRscMobTable:put_mob(iId, iCount)
    self.tiMobs[iId] = iCount
end

function CRscMobTable:collapse_mob_groups()
    local tiMobs = table_copy(self.tiMobs)
    self.tiMobs = collapse_mob_groups(tiMobs)
end
