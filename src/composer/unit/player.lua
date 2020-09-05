--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("composer.containers.units.player_table")
require("router.filters.path")
require("utils.provider.text.csv")
require("utils.provider.text.table")

local function load_exp_to_next_level(pUnitData, sFilePath)
    local tExpCsv = read_csv(sFilePath)
    if #tExpCsv > 0 then
        local tExpNeeded = tExpCsv[1]
        for _, pExpEntry in ipairs(tExpNeeded) do
            local iExp = tonumber(pExpEntry)
            pUnitData:add_exp_to_next_level(iExp)
        end
    end

end

local function load_player_data(sDirPath)
    local pUnitData = CPlayerDataTable:new()
    load_exp_to_next_level(pUnitData, sDirPath .. "/exp_table.txt")

    return pUnitData
end

function load_resources_player()
    local sDirPath = RPath.RSC_META_UNITS

    local pPlayerData = load_player_data(sDirPath)
    return pPlayerData
end
