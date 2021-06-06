--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("utils.persist.interface.routines")

local tfn_db_actions = {}

tfn_db_actions[RSqlFunction.NEW] =      function(rgpArgs)
                                            local pCon = rdbms_new(rgpArgs[2])
                                            pRdbms:set_rdbms_ds(rgpArgs[2])           -- session connection assigned

                                            return pCon
                                        end

tfn_db_actions[RSqlFunction.ADD] =      function(rgpArgs)
                                            return rdbms_kv_add(pRdbms:get_rdbms_ds(), rgpArgs[3], rgpArgs[5], rgpArgs[4])
                                        end

tfn_db_actions[RSqlFunction.DELETE] =   function(rgpArgs)
                                            return rdbms_kv_delete(pRdbms:get_rdbms_ds(), rgpArgs[3], rgpArgs[4], rgpArgs[5])
                                        end

tfn_db_actions[RSqlFunction.FETCH] =    function(rgpArgs)
                                            return rdbms_kv_fetch(pRdbms:get_rdbms_ds(), rgpArgs[3], rgpArgs[4], rgpArgs[5])
                                        end

tfn_db_actions[RSqlFunction.CLOSE] =    function(rgpArgs)
                                            --rdbms_close(pRdbms:get_rdbms_ds())
                                            --pRdbms:set_rdbms_ds(nil)
                                        end

function execute_rdbms_action(rgpArgs)
    local pFnType = tonumber(rgpArgs[1])

    local fn_action = tfn_db_actions[pFnType]
    return {fn_action(rgpArgs)}
end

function execute_rdbms_setup(sDataSource, tpTableCols)
    rdbms_setup(sDataSource, tpTableCols)
end
