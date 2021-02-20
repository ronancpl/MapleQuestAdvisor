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
local SSet = require("pl.class").Set

CSolverResource = createClass({
    pSetResources = SSet{}
})

function CSolverResource:get_resources()
    return self.pSetResources:values()
end

function CSolverResource:get_num_resources()
    return self.pSetResources:len()
end

function CSolverResource:set_resources(rgiResourceids)
    self.pSetResources = SSet{unpack(rgiResourceids)}
end
