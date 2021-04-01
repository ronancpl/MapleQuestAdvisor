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
require("utils.procedure.copy")
require("utils.procedure.unpack")
require("utils.struct.class")
require("utils.struct.mapqueue")

CActionHandler = createClass({
    rgsActions = {"on_mousemoved", "on_mousepressed", "on_mousereleased", "on_wheelmoved"},

    tpHandleActions = SMapQueue:new(),
    trgfn_actions = {}

})

function CActionHandler:reset()
    local m_tpHandleActions = self.tpHandleActions
    local m_rgsActions = self.rgsActions

    m_tpHandleActions:init(m_rgsActions)

    local m_trgfn_actions = self.trgfn_actions
    clear_table(m_trgfn_actions)
    for _, sFnName in ipairs(m_rgsActions) do
        m_trgfn_actions[sFnName] = {}
    end
end

function CActionHandler:install(sInteractionPath)
    local m_rgsActions = self.rgsActions
    local m_trgfn_actions = self.trgfn_actions

    local bReqHdl = require(sInteractionPath)
    if bReqHdl then
        for _, sFnName in ipairs(m_rgsActions) do
            local fn_action = _G[sFnName]

            local rgfn_acts = m_trgfn_actions[sFnName]
            table.insert(rgfn_acts, fn_action)
        end
    end
end

function CActionHandler:push(sFnName, rgpActionArgs)
    local m_tpHandleActions = self.tpHandleActions
    m_tpHandleActions:push(sFnName, rgpActionArgs)
end

function CActionHandler:_export_action(sFnName, iMaxPerAction)
    local m_trgfn_actions = self.trgfn_actions
    local m_tpHandleActions = self.tpHandleActions

    local rgpActions = {}

    local rgfn_actions = m_trgfn_actions[sFnName]
    if rgfn_actions ~= nil then
        iMaxPerAction = iMaxPerAction or U_INT_MAX

        local nActions = math.min(m_tpHandleActions:get_size(sFnName), iMaxPerAction)
        for i = 1, nActions, 1 do
            local rgpArgs = m_tpHandleActions:poll(sFnName)
            table.insert(rgpActions, rgpArgs)
        end

        rgfn_actions = table_copy(rgfn_actions)
    else
        rgfn_actions = {}
    end

    return rgfn_actions, rgpActions
end

function CActionHandler:export(iMaxPerAction)
    local m_rgsActions = self.rgsActions

    local rgpActions = {}
    for _, sFnName in ipairs(m_rgsActions) do
        local rgfn_actions
        local rgpArgs
        rgfn_actions, rgpArgs = self:_export_action(sFnName, iMaxPerAction)

        table.insert(rgpActions, {rgfn_actions, rgpArgs})
    end

    return rgpActions
end
