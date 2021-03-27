--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("router.procedures.constant")
require("utils.struct.class")
require("utils.struct.mapqueue")

CActionHandler = createClass({

    rgsActions = {"on_mousemoved", "on_mousepressed", "on_mousereleased"},

    tpHandleActions = SMapQueue:new(),
    tfn_actions = {}

})

function CActionHandler:install(sInteractionPath)
    local m_tpHandleActions = self.tpHandleActions
    local m_rgsActions = self.rgsActions
    local m_tfn_actions = self.tfn_actions

    m_tpHandleActions:init(m_rgsActions)

    local bReqHdl = require(sInteractionPath)
    if bReqHdl then
        for _, sFnName in ipairs(m_rgsActions) do
            local fn_action = _G[sFnName]
            m_tfn_actions[sFnName] = fn_action
        end
    end
end

function CActionHandler:push(sFnName, rgpActionArgs)
    local m_tpHandleActions = self.tpHandleActions
    m_tpHandleActions:push(sFnName, rgpActionArgs)
end

function CActionHandler:_export_action(sFnName, iMaxPerAction)
    local m_tfn_actions = self.tfn_actions
    local m_tpHandleActions = self.tpHandleActions

    local rgpActions = {}

    local fn_action = m_tfn_actions[sFnName]
    if fn_action ~= nil then
        iMaxPerAction = iMaxPerAction or U_INT_MAX
        local nActions = math.min(m_tpHandleActions:get_size(sFnName), iMaxPerAction)
        for i = 1, nActions, 1 do
            local rgpArgs = m_tpHandleActions:poll(sFnName)
            table.insert(rgpActions, rgpArgs)
        end
    end

    return fn_action, rgpActions
end

function CActionHandler:export(iMaxPerAction)
    local m_rgsActions = self.rgsActions

    local rgpActions = {}
    for _, sFnName in ipairs(m_rgsActions) do
        local fn_action
        local rgpArgs
        fn_action, rgpArgs = self:_export_action(sFnName, iMaxPerAction)

        table.insert(rgpActions, {fn_action, rgpArgs})
    end

    return rgpActions
end
