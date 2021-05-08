--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("ui.struct.canvas.quest.properties")
require("ui.struct.canvas.quest.layer.pathing")
require("utils.struct.class")

CWndQuest = createClass({
    pCanvas = CWndCanvas:new(),
    pProp = CQuestPathingProperties:new()
})

function CWndQuest:get_properties()
    return self.pProp
end

function CWndQuest:load()
    self.pProp:load(pRouteLane)
    self.pCanvas:load({CQuestNavPathing}) -- follows sequence: LLayer
end

function CWndQuest:update(dt)
    self.pCanvas:update(dt)
end

function CWndQuest:draw()
    self.pCanvas:draw()
end

function CWndQuest:onmousemoved(x, y, dx, dy, istouch)
    self.pCanvas:onmousemoved(x, y, dx, dy, istouch)
end

function CWndQuest:onmousepressed(x, y, button)
    self.pCanvas:onmousepressed(x, y, button)
end

function CWndQuest:onmousereleased(x, y, button)
    self.pCanvas:onmousereleased(x, y, button)
end

function CWndQuest:onwheelmoved(dx, dy)
    self.pCanvas:onwheelmoved(dx, dy)
end

function CWndQuest:get_layer(iLayer)
    return self.pCanvas:get_layer(iLayer)
end
