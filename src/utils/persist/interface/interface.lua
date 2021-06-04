--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("router.constants.persistence")
require("utils.persist.rdbms")
require("utils.persist.interface.session")
require("utils.procedure.copy")

function sleep(n)
    os.execute("sleep " .. tonumber(n))
end

function run_persist_interface(pRdbms)
    local i = 0
    repeat
        local tpCall = pRdbms:load_call()

        local tpRes = {}
        if next(tpCall) ~= nil then
            i = 0

            for rgpRdbmsArgs, _ in pairs(tpCall) do
                tpRes[rgpRdbmsArgs] = execute_rdbms_action(rgpRdbmsArgs)
            end

            pRdbms:store_all_results(tpRes)
        else
            if i >= RPersist.BUSY_RETRIES then
                sleep(RPersist.INTERFACE_SLEEP_MS)
            else
                i = i + 1
            end
        end
    until false

    clear_table(tpRes)
end

local function yield_response(rgpArgs)
    local pTmpRdbms = CRdbmsSession:new()
    pTmpRdbms:store_call(rgpArgs)

    local pRes
    local bCanSleep
    repeat
        pRes, bCanSleep = pTmpRdbms:pop_result(rgpArgs)   -- polls for result
        sleep(RPersist.SESSION_SLEEP_MS)
    until pRes ~= nil

    return pRes, bCanSleep
end

function send_rdbms_action(rgpRdbmsArgs)
    local rgpArgs = table_copy(rgpRdbmsArgs)
    local pRes, _ = yield_response(rgpArgs)

    return pRes
end
