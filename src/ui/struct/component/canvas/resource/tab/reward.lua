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
require("ui.struct.component.canvas.inventory.item")
require("ui.struct.component.element.texture")
require("utils.struct.class")

CRscRewardTab = createClass({
    pQuestAct,
    rgpVwItems = {},

    pTxtReward,

    iCursorX,
    iCursorY,

    eTextureRewardBox
})

function CRscRewardTab:_load_reward_items()
    local m_rgpVwItems = self.rgpVwItems

    local ivtItems = self.pQuestAct:get_items()

    local iPos = 0
    for iId, iCount in pairs(ivtItems:get_items()) do
        local iRy = (iPos % 4) * 32
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

function CRscRewardTab:load(pQuestAct)
    self.pQuestAct = pQuestAct

    self:_load_reward_items()
    self:_load_reward_box_texture()

    local pFont = love.graphics.newFont(RWndPath.LOVE_FONT_DIR_PATH .. "arial.ttf", 12)
    self.pTxtReward = love.graphics.newText(pFont)
end

function CRscRewardTab:_draw_reset()
    self.iCursorX = 0
    self.iCursorY = 0
end

function CRscRewardTab:_get_drawing_width()
    return self.iCursor * 120
end

function CRscRewardTab:_next_drawing_width()
    local iPx = self:_get_drawing_width()
    self.iCursor = self.iCursor + 1

    return iPx
end

function CRscRewardTab:_get_drawing_height()
    return self.iCursor * 27
end

function CRscRewardTab:_next_drawing_height()
    local iPy = self:_get_drawing_height()
    self.iCursor = self.iCursor + 1

    return iPy
end

function CRscRewardTab:_draw_exp()
    local iExp = self.pQuestAct:get_exp()
    if iExp ~= 0 then
        local pImgIcon = ctVwRscs:get_reward_types()[1]

        local iRx = self:_next_drawing_width()
        local iRy = self:_get_drawing_height()
        graphics_draw(pImgIcon, iPx + iRx, iPy + iRy)

        self.pTxtReward:setf({{1, 1, 1}, tostring(iExp)}, iLineWidth, "center")
        graphics_draw(self.pTxtReward, iPx + iRx, iPy + iRy + pImgIcon:getHeight() + 5)
    end
end

function CRscRewardTab:_draw_meso()
    local iMeso = self.pQuestAct:get_meso()
    if iMeso ~= 0 then
        local pImgIcon = ctVwRscs:get_reward_types()[2]

        local iRx = self:_next_drawing_width()
        local iRy = self:_get_drawing_height()

        graphics_draw(pImgIcon, iPx + iRx, iPy + iRy)

        self.pTxtReward:setf({{1, 1, 1}, tostring(iMeso)}, iLineWidth, "center")
        graphics_draw(self.pTxtReward, iPx + iRx, iPy + iRy + pImgIcon:getHeight() + 5)
    end
end

function CRscRewardTab:_draw_fame()
    local iFame = self.pQuestAct:get_fame()
    if iFame ~= 0 then
        local pImgIcon = ctVwRscs:get_reward_types()[3]

        local iRx = self:_next_drawing_width()
        local iRy = self:_get_drawing_height()
        graphics_draw(pImgIcon, iPx + iRx, iPy + iRy)

        self.pTxtReward:setf({{1, 1, 1}, tostring(iFame)}, iLineWidth, "center")
        graphics_draw(self.pTxtReward, iPx + iRx, iPy + iRy + pImgIcon:getHeight() + 5)
    end
end

function CRscRewardTab:_draw_items()
    local iPx = self:_next_drawing_width()
    local iPy = self:_next_drawing_height()

    local iTx, iTy = read_canvas_position()
    push_stack_canvas_position(iRx + iTx, iRy + iTy)
    for _, pVwItem in ipairs(rgpVwItems) do
        pVwItem:draw()
    end
    pop_stack_canvas_position()
end

function CRscRewardTab:_draw_reward_icon()
    local pImgIcon = ctVwRscs:get_reward_icon()
    graphics_draw(pImgIcon, self:_next_drawing_width(), self:_get_drawing_height())
end

function CRscRewardTab:draw()
    self:_draw_reset()

    self:_draw_exp()
    self:_draw_meso()
    self:_draw_fame()
    if self.pQuestAct:get_exp() ~= 0 or self.pQuestAct:get_meso() ~= 0 or self.pQuestAct:get_fame() ~= 0 then
        self:_next_drawing_height()
    end

    self:_draw_items()
end
