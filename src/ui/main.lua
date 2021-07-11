--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

package.path = package.path .. ';?.lua'

require("composer.containers.strings.item")
require("composer.containers.strings.mob")
require("composer.containers.strings.npc")
require("composer.quest.quest")
require("router.stages.load")
require("structs.player")
require("structs.storage.inventory")
require("ui.constant.path")
require("ui.run.control.player")
require("ui.run.control.route")
require("ui.run.update.navigation")
require("ui.trace.trace")
require("utils.logger.file")
require("utils.persist.serial.databus")
--require("utils.persist.serial.table")
require("utils.procedure.print")
require("utils.struct.ranked_set")

local function is_tree_leaf(pRscNode)
    return pRscNode.make_remissive_index_resource_fields == nil
end

local function make_remissive_index_tree_resource_fields(pRscNode)
    if not is_tree_leaf(pRscNode) then
        pRscNode:make_remissive_index_resource_fields()
        for _, pRegionRscTree in pairs(pRscNode:get_field_nodes()) do
            make_remissive_index_tree_resource_fields(pRegionRscTree)
        end
    end
end

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest", 1)
    love.graphics.setWireframe(love.keyboard.isDown('space'))

    log(LPath.INTERFACE, "load.txt", "Loading solver metadata...")

    dofile("router/stage.lua")
    dofile("router/route.lua")

    --dofile("persist/init.lua")    -- initialized as background process
    dofile("ui/stages/resources.lua")
    dofile("ui/stages/window.lua")
end

local function update_interactions()
    local rgpEvents = pEventHdl:export(nil, pWndHandler:get_focus_wnd())
    for _, pEvent in ipairs(rgpEvents) do
        local rgfn_actions
        local rgpActions
        rgfn_actions, rgpActions = unpack(pEvent)

        for _, pAction in ipairs(rgpActions) do
            local rgpArgs = pAction

            for _, fn_action in ipairs(rgfn_actions) do
                fn_action(unpack(rgpArgs))
            end
        end
    end
end

function love.update(dt)
    update_interactions()

    pFrameBasic:update(dt)

    pWndHandler:update()

    for _, pWnd in ipairs(pWndHandler:list_opened()) do
        pWnd:update(dt)
    end
end

function love.draw()
    for _, pWnd in ipairs(pWndHandler:list_opened()) do
        pWnd:draw()
    end
end

function love.mousemoved(x, y, dx, dy, istouch)
    pWndHandler:on_mousemoved(x, y, dx, dy, istouch)
    pEventHdl:push("on_mousemoved", {x, y, dx, dy, istouch})
end

function love.mousepressed(x, y, button)
    pEventHdl:push("on_mousepressed", {x, y, button})
end

function love.mousereleased(x, y, button)
    pEventHdl:push("on_mousereleased", {x, y, button})
end

function love.wheelmoved(dx, dy)
    pEventHdl:push("on_wheelmoved", {dx, dy})
end

function love.quit()
    dofile("persist/close.lua")
end
