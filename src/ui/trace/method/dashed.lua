--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("utils.procedure.euclidean")

local function calc_trace_params(x1, y1, x2, y2)
    local fM = (y2 - y1) / (x2 - x1)
    local fB = y2 - (fM * x2)

    return fM, fB
end

local function get_radius_from_trace(fM)
    return math.atan(fM)
end

local function fetch_trace_endpoints(fRad, x1, y1, x2, y2)
    local fRadA = fRad + (2 * math.pi)
    local fRadB = fRadA + math.pi

    local xA, yA, xB, yB
    if x1 < x2 then
        xA = x2
        yA = y2
        xB = x1
        yB = y1
    else
        xA = x1
        yA = y1
        xB = x2
        yB = y2
    end

    return fRadA, xA, yA, fRadB, xB, yB
end

local function calc_next_trace_endpoint(fRad, x, y, iDist)
    local nx = x + (math.cos(fRad) * iDist)
    local ny = y + (math.sin(fRad) * iDist)

    return nx, ny
end

local function get_inpoints_from_trace(fRad, x1, y1, x2, y2, iDist)
    local fRadA, xA, yA, fRadB, xB, yB = fetch_trace_endpoints(fRad, x1, y1, x2, y2)

    local iNextEpDist = iDist / 2
    xA, yA = calc_next_trace_endpoint(fRadA, xA, yA, -iNextEpDist)
    xB, yB = calc_next_trace_endpoint(fRadB, xB, yB, -iNextEpDist)

    return xA, yA, xB, yB
end

local function get_outpoints_from_trace(fRad, x1, y1, x2, y2, iDist)
    local fRadA, xA, yA, fRadB, xB, yB = fetch_trace_endpoints(fRad, x1, y1, x2, y2)

    local iNextEpDist = iDist / 2
    xA, yA = calc_next_trace_endpoint(fRadA, xA, yA, iNextEpDist)
    xB, yB = calc_next_trace_endpoint(fRadB, xB, yB, iNextEpDist)

    return xA, yA, xB, yB
end

local function find_trace_coords(x1, y1, x2, y2, iDistExt)
    local fM, fB = calc_trace_params(x1, y1, x2, y2)

    local fRad = get_radius_from_trace(fM)

    local xA, yA, xB, yB = get_outpoints_from_trace(fRad, x1, y1, x2, y2, iDistExt)
    return xA, yA, xB, yB
end

function find_inward_trace_coords(x1, y1, x2, y2, iDistExt)
    local fM, fB = calc_trace_params(x1, y1, x2, y2)

    local fRad = get_radius_from_trace(fM)

    return get_inpoints_from_trace(fRad, x1, y1, x2, y2, iDistExt)
end

local function calc_line_segments(x1, y1, x2, y2, iSgmts)
    local dx = (x2 - x1) / iSgmts
    local dy = (y2 - y1) / iSgmts

    local rgCoords = {}
    for i = 0, iSgmts, 1 do
        local cx = x1 + (i * dx)
        local cy = y1 + (i * dy)

        table.insert(rgCoords, cx)
        table.insert(rgCoords, cy)
    end

    return rgCoords
end

function fetch_segments_dashed(x1, y1, x2, y2, iDistSplit, iDistFill)
    local iDist = calc_distance({x1, x2, y1, y2})
    local iDistSgmt = iDistSplit + iDistFill

    local iSgmts = math.floor(iDist / iDistSgmt)
    local iIntervals = iSgmts + 1

    local iDistTrace = iDistSgmt * iSgmts + iDistFill
    local iDistExt = iDistTrace - iDist

    local xA, yA, xB, yB
    if iDistExt > 0 then
        xA, yA, xB, yB = find_trace_coords(x1, y1, x2, y2, iDistExt)
    else
        xA, yA, xB, yB = x1, y1, x2, y2
    end

    while true do
        local rgCoords = calc_line_segments(xA, yA, xB, yB, iSgmts)
        if rgCoords[1] ~= "nan" then
            break
        else
            iDistSplit = math.floor(iDistSplit / 2)
            iDistFill = math.floor(iDistFill / 2)

            if iDistSplit < 1 or iDistFill < 1 then
                rgCoords = nil
                break
            end
        end
    end

    return rgCoords
end
