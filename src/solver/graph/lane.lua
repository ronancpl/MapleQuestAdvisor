--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("router.constants.graph")
require("router.structs.lane")
require("router.structs.path")

local function make_sequence_subpaths(pPath)
    local rgpSubpaths = {}
    local rgfVals = {}

    local rgpQuestProps = pPath:list()
    local nQuestProp = #rgpQuestProps

    for i = 1, nQuestProp, 1 do
        local pSubpath = CQuestPath:new()

        for j = i, nQuestProp, 1 do
            local pQuestProp = rgpQuestProps[j]
            local fVal = pPath:get_node_value(j)
            local pQuestRoll = pPath:get_node_allot(j)

            pSubpath:add(pQuestProp, pQuestRoll, fVal)
        end

        table.insert(rgpSubpaths, pSubpath)
    end

    -- set subpath values
    rgfVals[nQuestProp + 1] = 0.0   -- symbolic next value
    for j = nQuestProp, 1, -1 do
        local fVal = pPath:get_node_value(j)
        rgfVals[j] = rgfVals[j + 1] + fVal
    end
    rgfVals[nQuestProp + 1] = nil

    return rgpSubpaths, rgfVals
end

local function create_inner_sublane_if_not_exists(pQuestLane, pQuestProp)
    local pSublane = pQuestLane:get_sublane(pQuestProp)
    if pSublane == nil then
        pSublane = CQuestLane:new()
        pSublane:set_capacity(RGraph.LEADING_PATH_CAPACITY)

        pQuestLane:add_sublane(pQuestProp, pSublane)
    end

    return pSublane
end

local function append_subpath_lane(pLane, rgpSubpaths, rgfVals)
    local pCurLane = pLane

    local nSubpaths = #rgpSubpaths
    for i = 1, nSubpaths, 1 do
        local pSubpath = rgpSubpaths[i]
        local fVal = rgfVals[i]

        local rgpQuestProps = pSubpath:list()
        local pQuestProp = rgpQuestProps[1]

        pCurLane:add_path(pSubpath, fVal)

        pCurLane = create_inner_sublane_if_not_exists(pCurLane, pQuestProp)
    end
end

local function is_subpath_in_lane(pQuestProp, pLane)   -- not repeat sublanes in base step
    return pQuestProp ~= nil and pLane:get_sublane(pQuestProp) ~= nil
end

function generate_subpath_lane(pSetRoutePaths)
    local pLane = CQuestLane:new()
    pLane:set_capacity(RGraph.LEADING_PATH_CAPACITY)

    for _, pPath in ipairs(pSetRoutePaths:list()) do
        local rgpSubpaths, rgfVals = make_sequence_subpaths(pPath)

        local pQuestProp = rgpSubpaths[1]
        if not is_subpath_in_lane(pQuestProp, pLane) then
            append_subpath_lane(pLane, rgpSubpaths, rgfVals)
        end
    end

    return pLane
end

function merge_subpath_lane(pLane, pOtherLane)
    pLane:merge_lane(pOtherLane)
end
