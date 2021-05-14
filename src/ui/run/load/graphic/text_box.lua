--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("composer.field.node.media.image")
require("ui.struct.component.canvas.style.mapno_box")

function load_node_text_box(pNodeTextbox, pRscProp)
    if pNodeTextbox == nil then     -- empty content
        return nil
    end

    local sTitle
    local sDesc
    sTitle, sDesc = pNodeTextbox:get_text()

    local pTextbox = CStyleBoxMapno:new()
    pTextbox:load(sTitle, sDesc, 100, 100, pRscProp)

    return pTextbox
end
