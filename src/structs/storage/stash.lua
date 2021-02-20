--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("composer.stash.access")
require("composer.stash.fitness")
require("router.filters.constant")
require("structs.storage.inventory")
require("utils.procedure.unpack")

CInventoryStash = createClass({
    ivtItems = CInventory:new(),
    tiPropItems = {},
    tfn_access_req = {},
    pPlayerState = nil
})

function CInventoryStash:_can_retrieve_item(iId)
    local m_pPlayerState = self.pPlayerState

    if m_pPlayerState ~= nil then
        local m_tiPropItems = self.tiPropItems

        local m_tfn_access_req = self.tfn_access_req
        local fn_entry_cond = m_tfn_access_req[iId]

        if fn_entry_cond ~= nil then
            if not fn_entry_cond(m_pPlayerState, m_tiPropItems) then
                return false
            end
        end
    end

    return true
end

function CInventoryStash:has_item(iId, iCount)
    local m_ivtItems = self.ivtItems
    return self:_can_retrieve_item(iId) and m_ivtItems:get_item(iId) > iCount
end

function CInventoryStash:get_item(iId)
    local m_ivtItems = self.ivtItems
    return self:_can_retrieve_item(iId) and m_ivtItems:get_item(iId) or 0
end

function CInventoryStash:add_prop_item(tpItems)
    local iPropUtil = {0, U_INT_MIN, U_INT_MIN}
    for iId, iCount in pairs(tpItems) do
        local iVal = calc_item_fitness(iId, iCount)
        if iVal > iPropUtil[3] then
            iPropUtil = {iId, iCount, iVal}
        end
    end

    local iId
    local iCount
    iId, iCount, _ = unpack(iPropUtil)
    if iId ~= 0 then
        tpItems[iId] = iCount
    end
end

function CInventoryStash:get_items()
    local m_pPlayerState = self.pPlayerState
    local m_ivtItems = self.ivtItems

    local tpItems = {}
    for iId, iCount in pairs(m_ivtItems:get_items()) do
        if self:_can_retrieve_item(iId) then
            tpItems[iId] = iCount
        end
    end

    self:add_prop_item(tpItems)

    return tpItems
end

function CInventoryStash:size()
    local i = 0
    for k, v in pairs(self:get_items()) do
        i = i + 1
    end

    return i
end

function CInventoryStash:set_fn_access(iId, iCount, iProp, siGender, siJob)
    local m_tfn_access_req = self.tfn_access_req
    m_tfn_access_req[iId] = fn_access_item(iId, iCount, iProp, siGender, siJob)
end

function CInventoryStash:remove_item(iId, iCount)
    local m_ivtItems = self.ivtItems
    m_ivtItems:remove_item(iId, iCount)

    if not m_ivtItems:has_item(iId, 1) then
        self:set_fn_access(iId, 0, 0, -1, -1)
    end
end

function CInventoryStash:add_item(iId, iCount)
    local m_ivtItems = self.ivtItems
    m_ivtItems:add_item(iId, iCount)

    if not m_ivtItems:has_item(iId, 1) then
        self:set_fn_access(iId, 0, 0, -1, -1)
    end
end

function CInventoryStash:set_item(iId, iCount)
    local m_ivtItems = self.ivtItems
    m_ivtItems:set_item(iId, iCount)

    if not m_ivtItems:has_item(iId, 1) then
        self:set_fn_access(iId, 0, 0, -1, -1)
    end
end

function CInventoryStash:_clear_access_items()
    local m_tfn_access_req = self.tfn_access_req
    for _, iId in ipairs(keys(m_tfn_access_req)) do
        m_tfn_access_req[iId] = nil
    end
end

function CInventoryStash:_clear_prop_items()
    local m_tiPropItems = self.tiPropItems
    for _, iId in ipairs(keys(m_tiPropItems)) do
        m_tiPropItems[iId] = nil
    end
end

function CInventoryStash:empty()
    local m_ivtItems = self.ivtItems
    m_ivtItems:empty()

    self:_clear_access_items()
    self:_clear_prop_items()
end

function CInventoryStash:install_player_state(pPlayerState)
    self:_clear_prop_items()
    self.pPlayerState = pPlayerState
end

function CInventoryStash:extract_player_state()
    self.pPlayerState = nil
end
