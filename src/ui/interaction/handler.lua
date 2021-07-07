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
    ttfn_actions = {},

    tpReqHdls = {}

})

function CActionHandler:reset()
    local m_tpHandleActions = self.tpHandleActions
    local m_rgsActions = self.rgsActions

    m_tpHandleActions:init(m_rgsActions)

    local m_ttfn_actions = self.ttfn_actions
    clear_table(m_ttfn_actions)
    for _, sFnName in ipairs(m_rgsActions) do
        m_ttfn_actions[sFnName] = {}
    end
end

function CActionHandler:install(sInteractionPath)
    local m_rgsActions = self.rgsActions
    local m_ttfn_actions = self.ttfn_actions

    local pReqHdl = require(sInteractionPath)
    if pReqHdl then
        self.tpReqHdls[sInteractionPath] = pReqHdl

        for _, sFnName in ipairs(m_rgsActions) do
            local fn_action = _G[sFnName]

            local tfn_acts = m_ttfn_actions[sFnName]
            tfn_acts[sInteractionPath] = fn_action
        end
    end
end

function CActionHandler:bind(sInteractionPath, pUiWnd)
    local pReqHdl = self.tpReqHdls[sInteractionPath]
    self.tpReqHdls[sInteractionPath] = nil  -- clear reference to handler

    self.tpReqHdls[pUiWnd] = pReqHdl        -- binds the interaction handler to UI window
end

function CActionHandler:push(sFnName, rgpActionArgs)
    local m_tpHandleActions = self.tpHandleActions
    m_tpHandleActions:push(sFnName, rgpActionArgs)
end

function CActionHandler:_export_action(sFnName, iMaxPerAction)
    local m_ttfn_actions = self.ttfn_actions
    local m_tpHandleActions = self.tpHandleActions

    local rgpActions = {}

    local tfn_actions = m_ttfn_actions[sFnName]
    if tfn_actions ~= nil then
        iMaxPerAction = iMaxPerAction or U_INT_MAX

        local nActions = math.min(m_tpHandleActions:get_size(sFnName), iMaxPerAction)
        for i = 1, nActions, 1 do
            local rgpArgs = m_tpHandleActions:poll(sFnName)
            table.insert(rgpActions, rgpArgs)
        end

        tfn_actions = table_copy(tfn_actions)
    else
        tfn_actions = {}
    end

    return tfn_actions, rgpActions
end

function CActionHandler:export(iMaxPerAction, pFocusWnd)
    local m_rgsActions = self.rgsActions

    local rgpActions = {}
    for _, sFnName in ipairs(m_rgsActions) do
        local tfn_actions
        local rgpArgs
        tfn_actions, rgpArgs = self:_export_action(sFnName, iMaxPerAction)

        local rgfn_actions = {}
        if pFocusWnd ~= nil and tfn_actions[pFocusWnd] ~= nil then
            table.insert(rgfn_actions, tfn_actions[pFocusWnd])
        else
            for _, fn_act in pairs(tfn_actions) do
                table.insert(rgfn_actions, fn_act)
            end
        end

        table.insert(rgpActions, {rgfn_actions, rgpArgs})
    end

    return rgpActions
end
