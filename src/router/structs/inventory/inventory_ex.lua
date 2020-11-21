--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("router.filters.constant")
require("structs.storage.inventory")
require("utils.struct.class")

CCompositeInventory = createClass({
    ivtRaw = CInventory:new(),
    ivtComp = CInventory:new(),
    ttiCompLimits = {},
    ivtExport = nil
})

function CCompositeInventory:get_raw()
    return self.ivtRaw
end

function CCompositeInventory:get_composite()
    return self.ivtComp
end

function CCompositeInventory:get_item(iId)
    return count_item(ivtEx, iId)
end

function CCompositeInventory:add_item(iId, iCount)
    add_item(self, iId, iCount)
end

function CCompositeInventory:get_limit(rgiItemids)
    local iCompLimit = U_INT_MAX

    for _, iItemid in ipairs(rgiItemids) do
        local iCompCount = self.ttiCompLimits[iItemid]
        if iCompCount < iCompLimit then
            iCompLimit = iCompCount
        end
    end

    return iCompLimit
end

function CCompositeInventory:apply_limit(iItemid, iQty)
    self.ttiCompLimits[iItemid] = iQty
end

function CCompositeInventory:commit_reload()
    self.ivtExport = nil
end

function CCompositeInventory:get_inventory()
    local m_ivtExport = self.ivtExport
    if m_ivtExport == nil then
        self.ivtExport = CInventory:new()
        m_ivtExport = self.ivtExport

        m_ivtExport:include_inventory(self.ivtRaw)
        m_ivtExport:include_inventory(self.ivtComp)
    end

    return m_ivtExport
end