--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("composer.containers.scripts.resources.base")
require("utils.struct.class")

CScriptSpawn = createClass({CScriptResource, {
    iId,
    bMob
}})

function CScriptSpawn:get_id()
    return self.iId
end

function CScriptSpawn:is_mob()
    return self.bMob
end