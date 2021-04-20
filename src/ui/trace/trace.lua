--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("ui.trace.polyline")
require("ui.trace.method.dashed")

function load_trace_dashed(x1, y1, x2, y2, pImgBullet, iLenSp)
    local fFill = 0.25  -- follow image proportions
    local rgiCoords = fetch_segments_dashed(x1, y1, x2, y2, (1 - fFill) * iLenSp, fFill * iLenSp)

    local rgVxs, rgIdxs, sDrawMode = polyline('none', rgiCoords, 3, 1.0, false)
    for i=1,#rgVxs,4 do
      rgVxs[i + 0][3], rgVxs[i + 0][4] = 0, 0
      rgVxs[i + 1][3], rgVxs[i + 1][4] = 0, 1
      rgVxs[i + 2][3], rgVxs[i + 2][4] = 1, 1
      rgVxs[i + 3][3], rgVxs[i + 3][4] = 1, 0
    end

    local pTraceMesh = love.graphics.newMesh(rgVxs, sDrawMode)
    pTraceMesh:setVertexMap(rgIdxs)
    pTraceMesh:setTexture(pImgBullet)

    return pTraceMesh
end
