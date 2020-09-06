--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("composer.containers.loots.maker")
require("utils.provider.text.csv")

local function init_maker_table(sFilePath)
    local ctMaker = CMakerTable:new()

    local tMakerRs = read_result_set(sFilePath, {"itemid"})
    if #tMakerRs > 1 then
        for _, tRow in ipairs(tMakerRs) do
            local iSrcid = tonumber(tRow["itemid"])
            ctMaker:add_maker_create_item(iSrcid)
        end
    end

    return ctMaker
end

function load_resources_maker()
    local sDirPath = RPath.RSC_META_LOOTS
    local sMakerPath = sDirPath .. "/makercreatedata.csv"

    local ctMaker = init_maker_table(sMakerPath)
    return ctMaker
end
