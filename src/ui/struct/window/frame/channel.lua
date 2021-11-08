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
require("utils.procedure.unpack")
require("utils.struct.class")

CWndChannel = createClass({
    tpRegisteredElements = {},
    tpElemHover = {}
})

function CWndChannel:load()
    local m_tpRegisteredElements = self.tpRegisteredElements
    clear_table(m_tpRegisteredElements)
end

function CWndChannel:update(dt)
    local m_tpRegisteredElements = self.tpRegisteredElements
    for _, pElem in ipairs(keys(m_tpRegisteredElements)) do
        pElem:update(dt)
    end
end

function CWndChannel:draw()
    local m_tpRegisteredElements = self.tpRegisteredElements
    for _, pElem in ipairs(keys(m_tpRegisteredElements)) do
        pElem:draw()
    end
end

function CWndChannel:add_element(pElem)
    local m_tpRegisteredElements = self.tpRegisteredElements
    m_tpRegisteredElements[pElem] = 1
end

function CWndChannel:remove_element(pElem)
    local m_tpRegisteredElements = self.tpRegisteredElements
    m_tpRegisteredElements[pElem] = nil

    local m_tpElemHover = self.tpElemHover
    m_tpElemHover[pElem] = nil
end

function CWndChannel:get_elements()
    local m_tpRegisteredElements = self.tpRegisteredElements
    return keys(m_tpRegisteredElements)
end

function CWndChannel:reset_elements()
    local m_tpRegisteredElements = self.tpRegisteredElements
    for _, pElem in ipairs(keys(m_tpRegisteredElements)) do
        pElem:reset()
    end

    clear_table(m_tpRegisteredElements)

    local m_tpElemHover = self.tpElemHover
    clear_table(m_tpElemHover)
end

local function is_mouse_in_range(pElem, x, y)
    local iLx, iTy, iRx, iBy = pElem:get_object():get_ltrb()
    return math.between(x, iLx, iRx) and math.between(y, iTy, iBy)
end

function CWndChannel:_update_state_hover(pElem, bHover)
    local m_tpElemHover = self.tpElemHover
    local bLastHover = m_tpElemHover[pElem] or false
    if bLastHover ~= bHover then
        m_tpElemHover[pElem] = bHover

        if bHover then
            local fn_onmousehoverin = pElem.onmousehoverin
            if fn_onmousehoverin ~= nil then
                fn_onmousehoverin(pElem)
            end
        else
            local fn_onmousehoverout = pElem.onmousehoverout
            if fn_onmousehoverout ~= nil then
                fn_onmousehoverout(pElem)
            end
        end
    end
end

function CWndChannel:_in_onmousemoved(pElem, x, y, dx, dy, istouch)
    local fn_onmousemoved = pElem.onmousemoved
    if fn_onmousemoved ~= nil then
        fn_onmousemoved(pElem, x, y, dx, dy, istouch)
    end
end

local function list_interactive_elements(pElem)
    local rgpInterElems = {}

    table.insert(rgpInterElems, pElem)
    if pElem.pSlider ~= nil then table.insert(rgpInterElems, pElem.pSlider) end

    return rgpInterElems
end

function CWndChannel:_list_interactive_elements()
    local rgpElems = {}

    local m_tpRegisteredElements = self.tpRegisteredElements
    for pElem, _ in pairs(m_tpRegisteredElements) do
        for _, pInterElem in ipairs(list_interactive_elements(pElem)) do
            table.insert(rgpElems, pInterElem)
        end
    end

    return rgpElems
end

function CWndChannel:onmousemoved(x, y, dx, dy, istouch, bToAll)
    local m_tpRegisteredElements = self.tpRegisteredElements

    local wx, wy = read_canvas_position()
    wx, wy = x - wx, y - wy

    for _, pElem in ipairs(self:_list_interactive_elements()) do
        local bHover = is_mouse_in_range(pElem, wx, wy)
        if bHover or bToAll then
            self:_in_onmousemoved(pElem, x, y, dx, dy, istouch)
        end

        if bToAll == nil then
            self:_update_state_hover(pElem, bHover)
        end
    end
end

function CWndChannel:_in_onmousepressed(pElem, x, y, button)
    local fn_onmousepressed = pElem.onmousepressed
    if fn_onmousepressed ~= nil then
        fn_onmousepressed(pElem, x, y, button)
    end
end

function CWndChannel:onmousepressed(x, y, button, bToAll)
    for _, pElem in ipairs(self:_list_interactive_elements()) do
        if is_mouse_in_range(pElem, x, y) or bToAll then
            self:_in_onmousepressed(pElem, x, y, button)
        end
    end
end

function CWndChannel:_in_onmousereleased(pElem, x, y, button)
    local fn_onmousereleased = pElem.onmousereleased
    if fn_onmousereleased ~= nil then
        fn_onmousereleased(pElem, x, y, button)
    end
end

function CWndChannel:onmousereleased(x, y, button, bToAll)
    for _, pElem in ipairs(self:_list_interactive_elements()) do
        if is_mouse_in_range(pElem, x, y) or bToAll then
            self:_in_onmousereleased(pElem, x, y, button)
        end
    end
end

function CWndChannel:hide_elements()
    for _, pElem in ipairs(self:_list_interactive_elements()) do
        if pElem.is_visible ~= nil then
            pElem:hidden()
        end
    end
end

function CWndChannel:_in_onwheelmoved(pElem, dx, dy)
    local fn_onwheelmoved = pElem.onwheelmoved
    if fn_onwheelmoved ~= nil then
        fn_onwheelmoved(pElem, dx, dy)
    end
end

function CWndChannel:onwheelmoved(dx, dy, bToAll)
    local x, y = love.mouse.getPosition()
    local wx, wy = read_canvas_position()

    x = x - wx
    y = y - wy

    for _, pElem in ipairs(self:_list_interactive_elements()) do
        if is_mouse_in_range(pElem, x, y) or bToAll then
            self:_in_onwheelmoved(pElem, dx, dy)
        end
    end
end
