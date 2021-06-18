--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("ui.run.control.procedures")
require("ui.struct.component.canvas.window.button")
require("utils.struct.class")

CWndUI = createClass({
    btGo,
    btSave,
    btLoad,
    btDelete
})

function CWndUI:_load_bt_go()
    local bt = CButtonElem:new()
    bt:load(RResourceTable.VW_BUTTON.GO)

    self.btGo = bt
end

function CWndUI:_load_bt_save()
    local bt = CButtonElem:new()

    bt:load(RResourceTable.VW_BUTTON.SAVE)
    bt:set_fn_trigger(fn_act, ...)

    self.btSave = bt
end

function CWndUI:_load_bt_load()
    local bt = CButtonElem:new()
    bt:load(RResourceTable.VW_BUTTON.OPEN)

    self.btLoad = bt
end

function CWndUI:_load_bt_delete()
    local bt = CButtonElem:new()
    bt:load(RResourceTable.VW_BUTTON.DELETE)

    self.btDelete = bt
end

function CWndUI:load()
    self:_load_bt_go()
    self:_load_bt_save()
    self:_load_bt_load()
    self:_load_bt_delete()
end

function CWndUI:update(dt)

end

function CWndUI:draw()


    CButtonElem:set_fn_trigger(fn_act, ...)

end
