--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("ui.run.draw.canvas.resource.mini_table")
require("ui.struct.component.basic.base")
require("utils.procedure.copy")
require("utils.procedure.unpack")
require("utils.struct.class")

CRscMinitableElem = createClass({
    eElem = CBasicElem:new(),
    rgeTextures = {},

    rgpTabVwItems = {}
})

function CRscMinitableElem:get_origin()
    return self.eElem:get_pos()
end

function CRscMinitableElem:get_object()
    return self.eElem
end

function CRscMinitableElem:get_background_tabs()
    return self.rgeTextures
end

function CRscMinitableElem:set_background_tabs(rgeTextures)
    self.rgeTextures = rgeTextures
end

function CRscMinitableElem:get_tab_item(siIdx)
    return self.rgpTabVwItems[siIdx]
end

function CRscMinitableElem:get_tab_items()
    return self.rgpTabVwItems
end

function CRscMinitableElem:_free_tab_items()
    local m_rgpTabVwItems = self.rgpTabVwItems
    local nTabs = #m_rgpTabVwItems

    for i = 1, nTabs, 1 do
        local rgpVwItems = m_rgpTabVwItems[i]
        for _, pVwItem in pairs(rgpVwItems) do
            pVwItem:free()
        end
    end
end

function CRscMinitableElem:_reset_tab_items()
    local m_rgpTabVwItems = self.rgpTabVwItems
    local nTabs = #m_rgpTabVwItems

    clear_table(m_rgpTabVwItems)

    for i = 1, nTabs, 1 do
        m_rgpTabVwItems[i] = {}
    end
end

function CRscMinitableElem:clear_tab_items()
    self:_free_tab_items()
    self:_reset_tab_items()
end

function CRscMinitableElem:add_tab_items(iTab, rgpVwItems)
    local m_rgpTabVwItems = self.rgpTabVwItems
    table_append(m_rgpTabVwItems[iTab], rgpVwItems)
end

function CRscMinitableElem:update_position(iRx, iRy)
    self.eElem:load(iRx, iRy)
end

function CRscMinitableElem:load(rX, rY)
    self.eElem:load(rX, rY)

    local m_rgpTabVwItems = self.rgpTabVwItems
    for i = 1, 4, 1 do
        m_rgpTabVwItems[i] = {}
    end

    load_minitable_tab_background(self)
end

function CRscMinitableElem:build()
    -- builds after load of each tab's items
    load_minitable_resources(self)
end

function CRscMinitableElem:update(dt)
    -- do nothing
end

function CRscMinitableElem:draw()
    draw_minitable_resources(self)
end
