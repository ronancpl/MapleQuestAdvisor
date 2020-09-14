--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

package.path = package.path .. ';?.lua'

require("router.stages.load")
require("router.stages.pool")
require("structs.player")

local function create_player()
    local pPlayer = CPlayer:new()

    return pPlayer
end

load_resources()

local pGridQuests = load_grid_quests(ctQuests)
local pPlayer = create_player()

local tQuests = pool_select_graph_quests(pGridQuests, pPlayer)
