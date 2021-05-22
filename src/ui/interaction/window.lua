--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("utils.procedure.unpack")
require("utils.struct.class")
require("utils.struct.mapqueue")

CWndHandler = createClass({
    tpWndClosed = {},
    tpWndOpened = {},

    tpActClosed = {},
    tpActOpened = {}
})

function CWndHandler:set_opened(pWnd)
    self.tpActOpened[pWnd] = 1
    self.tpWndClosed[pWnd] = nil
end

function CWndHandler:set_closed(pWnd)
    self.tpActClosed[pWnd] = 1
    self.tpWndOpened[pWnd] = nil
end

local function update_state(tpTo, tpFrom)
    table_merge(tpTo, tpFrom)
    clear_table(tpFrom)
end

function CWndHandler:update()
    update_state(self.tpWndClosed, self.tpActClosed)
    update_state(self.tpWndOpened, self.tpActOpened)
end

function CWndHandler:list_opened()
    return keys(self.tpWndOpened)
end

