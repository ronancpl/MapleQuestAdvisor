--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("ui.run.build.canvas.resource.entry")
require("ui.run.build.canvas.resource.field_enter")
require("ui.run.build.canvas.resource.item")
require("ui.run.build.canvas.resource.mob")
require("ui.run.build.canvas.resource.npc")
require("utils.struct.class")

CRscProperties = createClass({
    iCx = 0,
    iCy = 0,

    pVwTable,

    tpRscEntries = {},
    pRscTree,

    pInfoItem,
    pInfoMob,
    pInfoNpc,
    pInfoFieldEnter
})

function CRscProperties:get_table()
    return self.pVwTable
end

function CRscProperties:set_table(pVwTable)
    self.pVwTable = pVwTable
end

function CRscProperties:get_info_item()
    return self.pInfoItem
end

function CRscProperties:get_info_mob()
    return self.pInfoMob
end

function CRscProperties:get_info_npc()
    return self.pInfoNpc
end

function CRscProperties:get_info_field_enter()
    return self.pInfoFieldEnter
end

function CRscProperties:get_origin()
    return self.iCx, self.iCy
end

function CRscProperties:set_origin(iCx, iCy)
    self.iCx = iCx
    self.iCy = iCy
end

function CRscProperties:_update_items(tiItems)
    self.pInfoItem = CRscItemTable:new()

    for iId, iCount in pairs(tiItems) do
        self.pInfoItem:put_item(iId, iCount)
    end
end

function CRscProperties:_update_mobs(tiMobs)
    self.pInfoMob = CRscMobTable:new()

    for iId, iCount in pairs(tiMobs) do
        self.pInfoMob:put_mob(iId, iCount)
    end
end

function CRscProperties:_update_npc(iNpc)
    self.pInfoNpc = CRscNpcTable:new()
    self.pInfoNpc:set_npc(iNpc)
end

function CRscProperties:_update_field_enter(tFieldsEnter)
    self.pInfoFieldEnter = CRscFieldEnterTable:new()
    self.pInfoFieldEnter:set_fields(tFieldsEnter)
end

function CRscProperties:add_field_resources(iMapid, tiItems, tiMobs, iNpc, tFieldsEnter)
    local pRscEntry = CRscFieldEntry:new()

    pRscEntry:set_mobs(tiMobs)
    pRscEntry:set_items(tiItems)
    pRscEntry:set_npc(iNpc)
    pRscEntry:set_field_enter(tFieldsEnter)

    local m_tpRscEntries = self.tpRscEntries
    m_tpRscEntries[iMapid] = pRscEntry
end

function CRscProperties:_build_header_resources()
    local tiItems = {}
    local tiMobs = {}
    local iNpc = -1
    local tFieldsEnter = {}

    local m_tpRscEntries = self.tpRscEntries
    for iMapid, pRscEntry in pairs(m_tpRscEntries) do
        table_merge(tiItems, pRscEntry:get_items())
        table_merge(tiMobs, pRscEntry:get_mobs())
        iNpc = pRscEntry:get_npc() or iNpc
        table_merge(tFieldsEnter, pRscEntry:get_field_enter())
    end

    return tiItems, tiMobs, iNpc, tFieldsEnter
end

function CRscProperties:build()
    local tiItems, tiMobs, iNpc, tFieldsEnter = self:_build_header_resources()

    self:_update_items(tiItems)
    self:_update_mobs(tiMobs)
    self:_update_npc(iNpc)
    self:_update_field_enter(tFieldsEnter)
end

function CRscProperties:get_fields()
    local m_tpRscEntries = self.tpRscEntries
    return keys(m_tpRscEntries)
end

function CRscProperties:get_field_resources(iMapid)
    local m_tpRscEntries = self.tpRscEntries
    return m_tpRscEntries[iMapid]
end

function CRscProperties:get_resource_tree()
    return self.pRscTree
end

function CRscProperties:set_resource_tree(pRscTree)
    self.pRscTree = pRscTree
end
