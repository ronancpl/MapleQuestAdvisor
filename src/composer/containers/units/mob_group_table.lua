--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("composer.containers.units.unit_table")
require("utils.struct.class")

CMobGroupTable = createClass({CUnitTable, {sRscName = "mob_group"}})

function expand_mob_groups(tiMobs)
    for _, iSrcid in ipairs(keys(tiMobs)) do
        local rgiMobs = ctMobsGroup:get_locations(iSrcid)
        if #rgiMobs > 0 then
            for _, iMobid in ipairs(rgiMobs) do
                tiMobs[iMobid] = tiMobs[iSrcid]
            end
        end
    end

    return tiMobs
end

function collapse_mob_groups(tiMobs)
    for _, iSrcid in ipairs(keys(tiMobs)) do
        local rgiMobs = ctMobsGroup:get_locations(iSrcid)
        if #rgiMobs > 0 then
            table.sort(rgiMobs)

            for _, iMobid in ipairs(rgiMobs) do
                if iMobid ~= rgiMobs[1] then
                    tiMobs[iMobid] = nil
                end
            end
        end
    end

    return tiMobs
end
