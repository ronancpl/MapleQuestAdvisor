--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

RSqlFunction = {
    NEW = 0,
    ADD = 1,
    DELETE = 2,
    FETCH = 3,
    CLOSE = 4
}

local tfn_db_actions = {

    RSqlFunction.NEW =      function(rgpArgs)   -- global var assigned
                                local pCon = rdbms_new(rgpArgs[2])
                                pRdbms:set_rdbms_con(pCon)
                                return pCon
                            end,

    RSqlFunction.ADD =      function(rgpArgs)
                                return rdbms_kv_add(pRdbms:get_rdbms_con(), rgpArgs[2], rgpArgs[3])
                            end,

    RSqlFunction.DELETE =   function(rgpArgs)
                                return rdbms_kv_delete(pRdbms:get_rdbms_con(), rgpArgs[2])
                            end,

    RSqlFunction.FETCH =    function(rgpArgs)
                                return rdbms_kv_fetch(pRdbms:get_rdbms_con(), rgpArgs[2])
                            end,

    RSqlFunction.CLOSE =    function(rgpArgs)
                                rdbms_close(pRdbms:get_rdbms_con())
                                pRdbms:set_rdbms_con(nil)
                            end
}

function execute_rdbms_action(rgpArgs)
    local pFnType = rgpArgs[1]

    local fn_action = tfn_db_actions[pFnType]
    return {fn_action(rgpArgs)}
end
