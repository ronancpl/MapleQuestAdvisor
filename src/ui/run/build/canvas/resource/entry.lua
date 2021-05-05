--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("utils.procedure.copy")
require("utils.procedure.unpack")
require("utils.struct.class")

CRscFieldEntry = createClass({
    tiMobs = {},
    tiItems = {},
    iNpc = nil,
    tiFieldsEnter = {}
})

function CRscFieldEntry:get_mobs()
    return self.tiMobs
end

function CRscFieldEntry:set_mobs(tiMobs)
    local m_tiMobs = self.tiMobs

    clear_table(m_tiMobs)
    table_merge(m_tiMobs, tiMobs)
end

function CRscFieldEntry:get_items()
    return self.tiItems
end

function CRscFieldEntry:set_items(tiItems)
    local m_tiItems = self.tiItems

    clear_table(m_tiItems)
    table_merge(m_tiItems, tiItems)
end

function CRscFieldEntry:get_npc()
    return self.iNpc
end

function CRscFieldEntry:set_npc(iNpc)
    self.iNpc = iNpc
end

function CRscFieldEntry:get_field_enter()
    return self.tiFieldsEnter
end

function CRscFieldEntry:set_field_enter(tiFieldsEnter)
    local m_tiFieldsEnter = self.tiFieldsEnter

    clear_table(m_tiFieldsEnter)
    table_merge(m_tiFieldsEnter, tiFieldsEnter)
end
