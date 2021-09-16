--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("ui.constant.path")
require("ui.constant.view.resource")
require("ui.struct.component.canvas.inventory.item")
require("ui.struct.component.element.texture")
require("utils.struct.class")

CRscRewardTab = createClass({
    eBox = CUserboxElem:new(),

    pQuestAct,
    rgpVwItems = {},

    pTxtReward,

    iCursorX,
    iCursorY,

    eTextureRewardBox
})

function CRscRewardTab:get_origin()
    return self.eBox:get_origin()
end

function CRscRewardTab:set_position(iPx, iPy)
    self.eBox:set_position(iPx, iPy)
end

function CRscRewardTab:_clear_quest_rewards()
    local pQuestAct = CQuestAction:new()
    self.pQuestAct = pQuestAct

    local m_pQuestAct = self.pQuestAct

    m_pQuestAct:set_exp(0)
    m_pQuestAct:set_meso(0)
    m_pQuestAct:set_fame(0)
end

function CRscRewardTab:_load_quest_rewards(pQuest)
    local pQuestAct = CQuestAction:new()
    self.pQuestAct = pQuestAct

    local m_pQuestAct = self.pQuestAct

    local pQuestStartAct = pQuest:get_start():get_action()
    local pQuestEndAct = pQuest:get_end():get_action()

    m_pQuestAct:set_exp((pQuestStartAct:get_exp() or 0) + (pQuestEndAct:get_exp() or 0))
    m_pQuestAct:set_meso((pQuestStartAct:get_meso() or 0) + (pQuestEndAct:get_meso() or 0))
    m_pQuestAct:set_fame((pQuestStartAct:get_fame() or 0) + (pQuestEndAct:get_fame() or 0))

    for iId, iCount in pairs(pQuestStartAct:get_items():get_items()) do
        m_pQuestAct:add_item(iId, iCount, 0, 0, 0)
    end

    for iId, iCount in pairs(pQuestEndAct:get_items():get_items()) do
        m_pQuestAct:add_item(iId, iCount, 0, 0, 0)
    end
end

function CRscRewardTab:_load_reward_items()
    local m_rgpVwItems = self.rgpVwItems

    local ivtItems = self.pQuestAct:get_items()

    local iPos = 0
    for iId, iCount in pairs(ivtItems:get_items()) do
        local iRx = (iPos % 4) * 32
        local iRy = math.floor(iPos / 4) * 32
        iPos = iPos + 1

        local pVwItem = CInvtElemItem:new()
        pVwItem:load(iId, iCount)
        pVwItem:update_position(iRx, iRy)

        table.insert(m_rgpVwItems, pVwItem)
    end
end

function CRscRewardTab:_load_reward_box_texture()
    local pTextureData = ctVwRscs:get_reward_background_data()

    local eTexture = CTextureElem:new()
    pImgBox, iIx, iIy, iIw, iIh, iOx, iOy, iOw, iOh = pTextureData:get()
    eTexture:load(rX, rY, pImgBox, iIx, iIy, iIw, iIh, iOx, iOy, iOw, iOh)
    eTexture:build(400, 300)

    self.eTextureRewardBox = eTexture
end

function CRscRewardTab:load(iPx, iPy)
    self:_load_reward_box_texture()

    local pFont = love.graphics.newFont(RWndPath.LOVE_FONT_DIR_PATH .. "arial.ttf", 12)
    self.pTxtReward = love.graphics.newText(pFont)

    self:_clear_quest_rewards()

    self:set_position(iPx, iPy)
end

function CRscRewardTab:update_rewards(pQuest)
    if pQuest ~= nil then
        self:_load_quest_rewards(pQuest)
    else
        self:_clear_quest_rewards()
    end

    self:_load_reward_items()
end

function CRscRewardTab:_draw_reset()
    self.iCursorX = 0
    self.iCursorY = 0
end

function CRscRewardTab:_get_drawing_width()
    return self.iCursorX * 120
end

function CRscRewardTab:_next_drawing_width()
    local iPx = self:_get_drawing_width()
    self.iCursorX = self.iCursorX + 1

    return iPx
end

function CRscRewardTab:_get_drawing_height()
    return self.iCursorY * 27
end

function CRscRewardTab:_next_drawing_height()
    local iPy = self:_get_drawing_height()
    self.iCursorY = self.iCursorY + 1

    return iPy
end

function CRscRewardTab:_draw_exp()
    local iExp = self.pQuestAct:get_exp()
    if iExp ~= 0 then
        local pImgIcon = ctVwRscs:get_reward_types()[4]

        local iPx = RResourceTable.VW_GRID.REWARD.TYPE.EXP.X
        local iPy = RResourceTable.VW_GRID.REWARD.TYPE.EXP.Y

        local iRx = self:_next_drawing_width()
        local iRy = self:_get_drawing_height()

        local iTx, iTy = self:get_origin()

        graphics_draw(pImgIcon, iPx + iRx + iTx, iPy + iRy + iTy)

        self.pTxtReward:setf({{1, 1, 1}, tostring(iExp)}, 100, "left")
        graphics_draw(self.pTxtReward, iPx + iRx + iTx, iPy + iRy + pImgIcon:getHeight() + 5 + iTy)
    end
end

function CRscRewardTab:_draw_meso()
    local iMeso = self.pQuestAct:get_meso()
    if iMeso ~= 0 then
        local pImgIcon = ctVwRscs:get_reward_types()[3]

        local iPx = RResourceTable.VW_GRID.REWARD.TYPE.MESO.X
        local iPy = RResourceTable.VW_GRID.REWARD.TYPE.MESO.Y

        local iRx = self:_next_drawing_width()
        local iRy = self:_get_drawing_height()

        local iTx, iTy = self:get_origin()

        graphics_draw(pImgIcon, iPx + iRx + iTx, iPy + iRy + iTy)

        self.pTxtReward:setf({{1, 1, 1}, tostring(iMeso)}, 100, "left")
        graphics_draw(self.pTxtReward, iPx + iRx + iTx, iPy + iRy + pImgIcon:getHeight() + 5 + iTy)
    end
end

function CRscRewardTab:_draw_fame()
    local iFame = self.pQuestAct:get_fame()
    if iFame ~= 0 then
        local pImgIcon = ctVwRscs:get_reward_types()[2]

        local iPx = RResourceTable.VW_GRID.REWARD.TYPE.FAME.X
        local iPy = RResourceTable.VW_GRID.REWARD.TYPE.FAME.Y

        local iRx = self:_next_drawing_width()
        local iRy = self:_get_drawing_height()

        local iTx, iTy = self:get_origin()
        graphics_draw(pImgIcon, iPx + iRx + iTx, iPy + iRy + iTy)

        self.pTxtReward:setf({{1, 1, 1}, tostring(iFame)}, 100, "left")
        graphics_draw(self.pTxtReward, iPx + iRx + iTx, iPy + iRy + pImgIcon:getHeight() + 5 + iTy)
    end
end

function CRscRewardTab:_draw_items()
    local iPx = RResourceTable.VW_GRID.REWARD.TYPE.ITEMS.X
    local iPy = RResourceTable.VW_GRID.REWARD.TYPE.ITEMS.Y

    local iRx = self:_get_drawing_width()
    local iRy = self:_get_drawing_height()

    local iTx, iTy = self:get_origin()
    local pImgIcon = ctVwRscs:get_reward_types()[1]
    push_stack_canvas_position(iPx + iRx + iTx - 40, iPx + iRy + iTy + pImgIcon:getHeight() + 5)

    local m_rgpVwItems = self.rgpVwItems
    for _, pVwItem in ipairs(m_rgpVwItems) do
        pVwItem:draw()
    end

    pop_stack_canvas_position()
end

function CRscRewardTab:_draw_reward_icon()
    local iPx = RResourceTable.VW_GRID.REWARD.TYPE.ITEMS.X
    local iPy = RResourceTable.VW_GRID.REWARD.TYPE.ITEMS.Y

    local iRx = self:_next_drawing_width()
    local iRy = self:_get_drawing_height()

    local iTx, iTy = self:get_origin()

    local pImgIcon = ctVwRscs:get_reward_types()[1]
    graphics_draw(pImgIcon, iPx + iRx + iTx, iPy + iRy + iTy)
end

function CRscRewardTab:draw()
    self:_draw_reset()

    self:_draw_exp()
    self:_draw_meso()
    self:_draw_fame()
    if self.pQuestAct:get_exp() ~= 0 or self.pQuestAct:get_meso() ~= 0 or self.pQuestAct:get_fame() ~= 0 then
        self:_next_drawing_height()
    end

    self:_draw_reset()
    local m_rgpVwItems = self.rgpVwItems
    if #m_rgpVwItems > 0 then
        self:_draw_reward_icon()
        self:_next_drawing_height()

        self:_draw_items()
    end
end
