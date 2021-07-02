--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("router.constants.timer")
require("utils.procedure.unpack")
require("utils.struct.class")
require("utils.struct.maptimed")

CPool = createClass({

    ctInactives = SMapTimed:new(),
    tpEntries = {},

    fn_get_key,
    fn_create_item

})

function CPool:load(fn_get_key, fn_create_item)
    self.fn_get_key = fn_get_key
    self.fn_create_item = fn_create_item
end

function CPool:_fetch_object(...)
    local m_fn_get_key = self.fn_get_key
    local iKey = m_fn_get_key(unpack(...))

    local m_tpEntries = self.tpEntries
    local rgpObjs = create_inner_table_if_not_exists(m_tpEntries, iKey)

    local pObj = table.remove(rgpObjs)
    if pObj ~= nil then
        self.ctInactives:remove(pObj)
    end

    return pObj
end

function CPool:_take_object(...)
    local pObj = self:_fetch_object(...)
    if pObj == nil then
        pObj = self.fn_create_item(unpack(...))
        self.ctInactives:insert(pObj, 1, RTimer.TM_UI_POOL)
    end

    return pObj
end

function CPool:take_object(...)
    local pObj = self:_take_object(...)
    return pObj
end

function CPool:put_object(pObj, ...)
    local m_fn_get_key = self.fn_get_key
    local iKey = m_fn_get_key(unpack(...))

    local rgpObjs = create_inner_table_if_not_exists(self.tpEntries, iKey)

    table.insert(rgpObjs, pObj)
    self.ctInactives:insert(pObj, 1, RTimer.TM_UI_POOL)
end
