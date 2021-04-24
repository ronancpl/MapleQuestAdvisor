--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("ui.run.build.canvas.resource.field_enter")
require("ui.run.build.canvas.resource.item")
require("ui.run.build.canvas.resource.mob")
require("ui.run.build.canvas.resource.npc")
require("utils.struct.class")

CRscProperties = createClass({
    iCx = 0,
    iCy = 0,

    pVwTable,

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

function CRscProperties:_update_field_enter(iFieldEnter)
    self.pInfoFieldEnter = CRscFieldEnterTable:new()
    self.pInfoFieldEnter:set_field(iFieldEnter)
end

function CRscProperties:update_resources(tiItems, tiMobs, iNpc, iFieldEnter)
    self:_update_items(tiItems)
    self:_update_mobs(tiMobs)
    self:_update_npc(iNpc)
    self:_update_field_enter(iFieldEnter)
end
