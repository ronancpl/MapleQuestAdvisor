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
    for pElem, _ in pairs(m_tpRegisteredElements) do
        pElem:update(dt)
    end
end

function CWndChannel:draw()
    local m_tpRegisteredElements = self.tpRegisteredElements
    for pElem, _ in pairs(m_tpRegisteredElements) do
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
    for pElem, _ in pairs(m_tpRegisteredElements) do
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
            pElem:onmousehoverin()
        else
            pElem:onmousehoverout()
        end
    end
end

function CWndChannel:onmousemoved(x, y, dx, dy, istouch)
    local m_tpRegisteredElements = self.tpRegisteredElements
    for pElem, _ in pairs(m_tpRegisteredElements) do
        local bHover = is_mouse_in_range(pElem, x, y)
        if bHover then
            pElem:onmousemoved(x, y, dx, dy, istouch)
        end

        self:_update_state_hover(pElem, bHover)
    end
end

function CWndChannel:onmousepressed(x, y, button)
    local m_tpRegisteredElements = self.tpRegisteredElements
    for pElem, _ in pairs(m_tpRegisteredElements) do
        if is_mouse_in_range(pElem, x, y) then
            pElem:onmousepressed(x, y, button)
        end
    end
end

function CWndChannel:onmousereleased(x, y, button)
    local m_tpRegisteredElements = self.tpRegisteredElements
    for pElem, _ in pairs(m_tpRegisteredElements) do
        if is_mouse_in_range(pElem, x, y) then
            pElem:onmousereleased(x, y, button)
        end
    end
end
