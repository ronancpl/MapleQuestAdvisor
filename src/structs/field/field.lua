--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("utils.struct.array")
require("utils.struct.class")

CField = createClass({
    iMapid = -1,
    bTown = false,
    rgpNpcs = SArray:new(),
    rgpMobs = SArray:new(),
    rgpReactors = SArray:new()
})

function CField:get_mapid()
    return self.iMapid
end

function CField:set_mapid(iMapid)
    self.iMapid = iMapid
end

function CField:is_town()
    return self.bTown
end

function CField:set_town(bTown)
    self.bTown = bTown
end

function CField:get_npcs()
    return self.rgpNpcs
end

function CField:get_mobs()
    return self.rgpMobs
end

function CField:get_reactors()
    return self.rgpReactors
end
