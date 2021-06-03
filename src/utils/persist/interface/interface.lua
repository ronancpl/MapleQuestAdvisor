--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("utils.persist.interface.rdbms")
require("utils.procedure.copy")

function run_persist_interface()
    sleep()     -- gets to start on use

    local tpCall = pSrvRdbms:get_table_calls()
    local tpRes = pSrvRdbms:get_table_results()

    repeat
        for rgpRdbmsArgs, _ in pairs(tpCall) do
            tpRes[rgpRdbmsArgs] = execute_rdbms_action(rgpRdbmsArgs)
        end
    until false

    clear_table(tpRes)
end

local function yield_response(rgpArgs)
    local tpCall = pSrvRdbms:get_table_calls()
    local tpRes = pSrvRdbms:get_table_results()

    tpCall[rgpArgs] = 1

    local pRes
    repeat
        pRes = tpRes[rgpArgs]   -- polls for result
    until pRes ~= nil

    tpRes[rgpArgs] = nil
    tpCall[rgpArgs] = nil

    return pRes, next(tpCall) == nil
end

local function sleep()

end

local function wake()

end

function send_rdbms_action(rgpRdbmsArgs)
    wake()

    local rgpArgs = table_copy(rgpRdbmsArgs)
    local pRes, bCanSleep = yield_response(rgpArgs)
    if bCanSleep then
        sleep()
    end

    return pRes
end
