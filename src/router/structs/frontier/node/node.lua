--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("router.structs.frontier.properties")
require("utils.struct.array")
require("utils.struct.class")

CQuestFrontierNode = createClass({
    bList = false,
    rgpItems = SArray:new(),
    pQuestAcc = nil,
    fn_attain = nil,
    fn_diff = nil,
    fn_player_property = nil,
    fn_compare = nil,
    fn_create = nil
})

function CQuestFrontierNode:get_fn_attain()
    return self.fn_attain
end

function CQuestFrontierNode:get_fn_diff()
    return self.fn_diff
end

function CQuestFrontierNode:get_fn_player_property()
    return self.fn_player_property
end

function CQuestFrontierNode:get_fn_compare()
    return self.fn_compare
end

function CQuestFrontierNode:get_fn_create()
    return self.fn_create
end

function CQuestFrontierNode:size()
    return self.rgpItems:size()
end

local fn_sample = function(v) return v:get_property():get_quest_id() end
local fn_upd = function(v) return v:get_property():get_quest_id() end

function CQuestFrontierNode:debug_info(m_rgpItems, fn_compare, pFrontierProp, sAny, fn_info)
    local st = ""
    for _, v in ipairs(m_rgpItems:list()) do
        if fn_info then
            st = st .. fn_info(v) .. "|"
        end

        st = st .. fn_compare(v, pFrontierProp) .. ", "
    end
    print(sAny, m_rgpItems, "[" .. st .. "]")
end

function CQuestFrontierNode:add(pQuestProp, pQuestChkProp)
    local m_pQuestAcc = self.pQuestAcc
    local fn_create = self:get_fn_create()
    local fn_compare = self:get_fn_compare()

    local pFrontierProp = fn_create(m_pQuestAcc, pQuestProp, pQuestChkProp)

    local m_rgpItems = self.rgpItems

    self:debug_info(m_rgpItems, fn_compare, pFrontierProp, "<<", fn_sample)

    local iInsIdx = m_rgpItems:bsearch(fn_compare, pFrontierProp, true, true)

    print("ins: " .. iInsIdx, fn_compare, pFrontierProp:get_property():get_quest_id())

    m_rgpItems:insert(pFrontierProp, iInsIdx)

    self:debug_info(m_rgpItems, fn_compare, pFrontierProp, ">>", fn_sample)
    print("----------")
end

function CQuestFrontierNode:find(pQuestProp)
    local fn_select = function(pOtherProp)
        return pQuestProp:compare(pOtherProp:get_property()) == 0
    end

    local m_rgpItems = self.rgpItems
    local iIdx = m_rgpItems:index_of(fn_select, false)
    return iIdx
end

function CQuestFrontierNode:contains(pQuestProp)
    local iRmvIdx = self:find(pQuestProp)
    return iRmvIdx > 0
end

function CQuestFrontierNode:count()
    local m_rgpItems = self.rgpItems
    return m_rgpItems:size()
end

function CQuestFrontierNode:remove(pQuestProp)
    local iRmvIdx = self:find(pQuestProp)
    if iRmvIdx > 0 then
        local m_rgpItems = self.rgpItems
        m_rgpItems:remove(iRmvIdx, iRmvIdx)
    end
end

local function fetch_update_iterator_step(rgpItems, bSelect, iIdx)
    local iStart
    local iEnd

    if bSelect then
        iStart = iIdx - 1
        iEnd = rgpItems:size()
    else
        iStart = 1
        iEnd = iIdx
    end

    return iStart, iEnd
end

function CQuestFrontierNode:update_take(pPlayerState, bSelect)
    local m_pQuestAcc = self.pQuestAcc
    local m_fn_diff = self:get_fn_diff()

    local fn_attainable = m_pQuestAcc:get_fn_attainable()

    local m_rgpItems = self.rgpItems
    self:debug_info(m_rgpItems, fn_attainable(m_fn_diff, m_pQuestAcc), pPlayerState, ">>>", fn_upd)

    m_rgpItems:sort(function(a, b) return fn_attainable(m_fn_diff, m_pQuestAcc)(a, b) > 0 end)
    local iIdx = m_rgpItems:bsearch(fn_attainable(m_fn_diff, m_pQuestAcc), pPlayerState, true, true)

    local iStart
    local iEnd
    iStart, iEnd = fetch_update_iterator_step(m_rgpItems, bSelect, iIdx)

    local rgpFrontierProps = m_rgpItems:remove(iStart, iEnd)

    self:debug_info(m_rgpItems, fn_attainable(m_fn_diff, m_pQuestAcc), pPlayerState, "<<<", fn_upd)

    return rgpFrontierProps
end

function CQuestFrontierNode:update_put(rgpFrontierProps, pPlayerState)
    local m_rgpItems = self.rgpItems
    local m_pQuestAcc = self.pQuestAcc
    local m_fn_diff = self:get_fn_diff()

    local fn_attainable = m_pQuestAcc:get_fn_attainable()

    self:debug_info(m_rgpItems, fn_attainable(m_fn_diff, m_pQuestAcc), pPlayerState, "+++", fn_upd)

    m_rgpItems:add_all(rgpFrontierProps)

    self:debug_info(m_rgpItems, fn_attainable(m_fn_diff, m_pQuestAcc), pPlayerState, "|||", fn_upd)
    print("----------------")
end
