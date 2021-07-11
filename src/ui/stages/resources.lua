--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("ui.run.build.canvas.worldmap.worldmap")
require("ui.struct.component.canvas.inventory.storage")
require("ui.struct.component.canvas.resource.storage")
require("ui.struct.component.canvas.style.storage")
require("ui.struct.component.canvas.slider.storage")
require("ui.struct.component.tooltip.button.storage")
require("ui.struct.component.tooltip.mouse.storage")
require("ui.struct.component.tooltip.tracer.storage")
require("ui.struct.images.storage.item")
require("ui.struct.images.storage.mob")
require("ui.struct.images.storage.npc")
require("ui.struct.window.pool.canvas_pool")
require("ui.struct.window.pool.font_pool")
require("ui.struct.window.pool.image_pool")
require("ui.struct.window.pool.worldmap_pool")
require("utils.logger.file")
require("utils.persist.act.call")
require("utils.struct.maptimed")

tpDbTableCols = load_db_table_cols()

ctFieldsWmap = load_resources_worldmap_ui()

log(LPath.INTERFACE, "load.txt", "Loading graphic asset...")

ctPoolCnv = CPoolCanvas:new()
ctPoolCnv:init()

ctPoolFont = CPoolFont:new()
ctPoolFont:init()

ctPoolImg = CPoolImage:new()
ctPoolImg:init()

ctPoolWmap = CPoolWorldmap:new()
ctPoolWmap:init()

ctInactiveTextures = SMapTimed:new()

ctHrItems = load_image_header_inventory()
ctHrMobs = load_image_header_mobs()
ctHrNpcs = load_image_header_npcs()

ctVwStyle = load_image_stock_stylebox()
ctVwInvt = load_image_stock_inventory()
ctVwRscs = load_image_stock_resources()
ctVwCursor = load_image_stock_mouse()
ctVwButton = load_image_stock_button()
ctVwSlider = load_image_stock_slider()
ctVwTracer = load_image_stock_tracer()
