--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("ui.struct.component.element.dynamic")
require("utils.procedure.splitter")
require("utils.procedure.unpack")
require("utils.struct.class")

CViewPolyline = createClass({
    eDynam = CDynamicElem:new(),
    rgpDynMesh = {}
})

function CViewPolyline:load(rgpQuads, ...)
    local m_rgpDynMesh = self.rgpDynMesh
    clear_table(m_rgpDynMesh)

    self.eDynam:load(0, 0, rgpQuads)

    for _, pImgQuad in ipairs(rgpQuads) do
        local rgpQuadMesh = {}
        table.insert(m_rgpDynMesh, rgpQuadMesh)

        local rgpCoords = split_tuples(2, ...)
        local nCoords = #rgpCoords
        if nCoords > 1 then
            local iX1, iY1
            local iX2, iY2

            iX1, iY1 = unpack(rgpCoords[1])
            for i = 2, nCoords, 1 do
                iX2, iY2 = unpack(rgpCoords[i])

                local pTraceMesh = load_trace_dashed(iX1, iY1, iX2, iY2, pImgQuad, 50)
                table.insert(rgpQuadMesh, pTraceMesh)

                iX1, iY1 = iX2, iY2
            end
        end
    end
end

function CViewPolyline:update(dt)
    self.eDynam:update(dt)
end

function CViewPolyline:draw()
    local iCurQuad = self.eDynam:get_instant()

    local m_rgpDynMesh = self.rgpDynMesh
    for _, pTraceMesh in ipairs(m_rgpDynMesh[iCurQuad]) do
        love.graphics.draw(pTraceMesh, 0, 0)
    end
end
