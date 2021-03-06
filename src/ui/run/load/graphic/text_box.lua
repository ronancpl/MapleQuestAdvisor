--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("ui.struct.worldmap.element.textbox")

function load_node_text_box(pNodeTextbox)
    if pNodeTextbox == nil then     -- empty content
        return nil
    end

    local sTitle
    local sDesc
    sTitle, sDesc = pNodeTextbox:get_text()

    local pTextbox = CWmapElemTextBox:new()
    pTextbox:set_title(sTitle)
    pTextbox:set_desc(sDesc)

    local pImgBox = love.graphics.newImage(RInterface.LOVE_IMAGE_DIR_PATH .. RInterface.SBOX_DESC)

    local iOx
    local iOy
    local iZ = 1
    iOx, iOy = love.mouse.getPosition()

    pTextbox:load(pImgBox, iOx, iOy, iZ, 100, 100)

    return pTextbox
end
