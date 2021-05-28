--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("router.structs.inventory.inventory_ex")
require("structs.storage.inventory")
require("utils.struct.class")

CPlayer = createClass({
    siJob = -1,
    siLevel = 1,
    liExp = 0,
    liExpUpdt = 0,
    iMapid = 0,
    iMeso = 0,
    siFame = 0,
    siGender = -1,
    ivtItems = CCompositeInventory:new(),
    ivtSkills = CInventory:new(),
    ivtQuests = CInventory:new(),
    ivtMobs = CInventory:new()
})

function CPlayer:get_job()
    return self.siJob
end

function CPlayer:set_job(siJob)
    self.siJob = siJob
end

function CPlayer:_update_exp_over_level(bUndo, iExpOver)
    if bUndo then
        self.siLevel = self.siLevel - 1
        iExpOver = iExpOver + ctPlayersMeta:get_exp_to_next_level(self.siLevel)
    else
        iExpOver = iExpOver - ctPlayersMeta:get_exp_to_next_level(self.siLevel)
        self.siLevel = self.siLevel + 1
    end

    return iExpOver
end

function CPlayer:_update_exp()
    if self.liExpUpdt >= 0 and self.liExpUpdt < ctPlayersMeta:get_exp_to_next_level(self.siLevel) then
        self.liExp = self.liExpUpdt
    else
        local iExpOver = self.liExpUpdt - (self.liExpUpdt >= 0 and self.liExp or 0)

        local iExpSt = self.liExp
        while true do
            if iExpOver < 0 then
                iExpSt = 0
                iExpOver = self:_update_exp_over_level(true, iExpOver)
            elseif iExpSt + iExpOver >= ctPlayersMeta:get_exp_to_next_level(self.siLevel) then
                iExpSt = 0
                iExpOver = self:_update_exp_over_level(false, iExpOver)
            else
                break
            end
        end

        self.liExp = iExpOver
    end
end

function CPlayer:get_level()
    return self.siLevel
end

function CPlayer:set_level(siLevel)
    self.siLevel = siLevel
    self._update_exp_amass()
end

function CPlayer:get_exp()
    return self.liExp
end

function CPlayer:set_exp(liExp)
    self.liExpUpdt = liExp
    self:_update_exp()
end

function CPlayer:add_exp(liExp)
    self.liExpUpdt = self.liExp + liExp
    self:_update_exp()
end

function CPlayer:get_mapid()
    return self.iMapid
end

function CPlayer:set_mapid(iMapid)
    self.iMapid = iMapid
end

function CPlayer:get_meso()
    return self.iMeso
end

function CPlayer:set_meso()
    self.iMeso = iMeso
end

function CPlayer:add_meso(iMeso)
    self.iMeso = self.iMeso + iMeso
end

function CPlayer:get_fame()
    return self.siFame
end

function CPlayer:set_fame(siFame)
    self.siFame = siFame
end

function CPlayer:add_fame(siFame)
    self.siFame = self.siFame + siFame
end

function CPlayer:get_gender()
    return self.siGender
end

function CPlayer:set_gender(siGender)
    self.siGender = siGender
end

function CPlayer:get_items()
    return self.ivtItems
end

function CPlayer:get_skills()
    return self.ivtSkills
end

function CPlayer:get_quests()
    return self.ivtQuests
end

function CPlayer:get_mobs()
    return self.ivtMobs
end

function CPlayer:export_table()
    local tpItems = {}

    tpItems.siJob = self.siJob
    tpItems.siLevel = self.siLevel
    tpItems.liExp = self.liExp
    tpItems.liExpUpdt = self.liExpUpdt
    tpItems.iMapid = self.iMapid
    tpItems.iMeso = self.iMeso
    tpItems.siFame = self.siFame
    tpItems.siGender = self.siGender

    return tpItems
end

function CPlayer:export_inventory_tables()
    local rgpInvts = {}

    table.insert(rgpInvts, ivtItems:export_table())
    table.insert(rgpInvts, ivtSkills:export_table())
    table.insert(rgpInvts, ivtQuests:export_table())
    table.insert(rgpInvts, ivtMobs:export_table())

    return rgpInvts
end

function CPlayer:debug_player_state()
    local st = ""
    st = st .. " JOB: " .. self.siJob
    st = st .. " LVL: " .. self.siLevel
    st = st .. " EXP: " .. self.liExp
    st = st .. " MAPID: " .. self.iMapid
    st = st .. " MESO: " .. self.iMeso
    st = st .. " FAME: " .. self.siFame
    print(st)
    print("===============")

    print("ITEMS:")
    self.ivtItems:debug_inventory()

    print("SKILLS:")
    self.ivtSkills:debug_inventory()

    print("QUESTS:")
    self.ivtQuests:debug_inventory()

    print("MOBS:")
    self.ivtMobs:debug_inventory()

    print("===============")
    print()
end
