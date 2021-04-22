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
require("ui.constant.path")
require("utils.struct.class")

CStockTracer = createClass({
    rgpQuadTrace
})

function load_animation_bullet()
    local pDirTracerQuads = load_quad_storage_from_wz_sub(RWndPath.INTF_UI_WND, "EnergyBar")
    pDirTracerQuads = select_animations_from_storage(pDirTracerQuads, {"effect"})

    local rgpQuads = find_animation_on_storage(pDirTracerQuads, "effect")
    return rgpQuads
end

function CStockTracer:_load_tracer_images()
    self.rgpQuadTrace = load_animation_bullet()
end

function CStockTracer:load()
    self:_load_tracer_images()
end

function CStockTracer:get_bullet()
    return self.rgpQuadTrace
end

function load_image_stock_tracer()
    local ctVwTracer = CStockTracer:new()
    ctVwTracer:load()

    return ctVwTracer
end
