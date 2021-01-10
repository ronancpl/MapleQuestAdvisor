--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("solver.assignment.constant")
require("solver.assignment.structs.table")

local function init_table(iRows, iCols, rgpTableValues)
    local pTable = CApTable:new()

    for i = 1, iRows, 1 do    -- clone rows in order to have same agent multiple tasks assignment
        local rgiVals = rgpTableValues[i]

        local rgiRowVals = {}
        for j = 1, iCols, 1 do
            table.insert(rgiRowVals, rgiVals[j])
        end

        pTable:add_row(i, rgiRowVals)
    end

    pTable:set_columns(iCols)

    pTable:set_num_agents(iRows)
    pTable:set_num_tasks(iCols)

    return pTable
end

local function clone_agent_task_table(pTable, iNumAgentClones)
    local nAgents = pTable:get_num_agents()

    for i = 1, iNumAgentClones, 1 do    -- clone rows in order to have same agent multiple tasks assignment
        for j = 1, nAgents, 1 do
            local rgValues = pTable:get_row_values(j)
            pTable:add_row(j, rgValues)
        end
    end
end

local function normalize_table(pTable)
    local nRows = pTable:get_num_rows()
    local nCols = pTable:get_num_columns()

    if nRows ~= nCols then
        local nAgents = nRows

        if nRows < nCols then
            local nAgentClones = math.ceil((nCols - nRows) / nAgents)
            clone_agent_task_table(pTable, nAgentClones)

            nRows = pTable:get_num_rows()
            nCols = pTable:get_num_columns()
        end

        if nCols < nRows then
            local rgiZeroedCol = {}
            for i = 1, nRows, 1 do table.insert(rgiZeroedCol, 0) end

            local iDummyCols = nRows - nCols
            for i = 1, iDummyCols, 1 do
                pTable:add_column(rgiZeroedCol)
            end
        elseif nCols > nRows then
            local rgiZeroedRow = {}
            for i = 1, nCols, 1 do table.insert(rgiZeroedRow, 0) end

            local iDummyRows = nCols - nRows
            for i = 1, iDummyRows, 1 do
                pTable:add_row(-1, rgiZeroedRow)
            end
        end
    end
end

local function init_sequence_metadata(rgpSequences)
    local nSequences = #rgpSequences
    for i = 1, nSequences, 1 do
        local pLine = rgpSequences[i]

        pLine:set_index(i)
        pLine:clear_flag()
    end
end

local function init_table_cell_metadata(pTable)
    local rgpRows = pTable:get_rows()
    for _, pRow in ipairs(rgpRows) do
        local rgpCells = pTable:get_row_elements(pRow)

        for _, pCell in ipairs(rgpCells) do
            pCell:clear_flag()
        end
    end
end

local function init_table_metadata(pTable)
    init_sequence_metadata(pTable:get_rows())
    init_sequence_metadata(pTable:get_columns())

    init_table_cell_metadata(pTable)
end

local function assemble_agent_task_table(pTable)
    clone_agent_task_table(pTable, RSolver.AP_NUM_TASKS_PER_AGENT - 1)
end

local function debug_flag_value(pElem, bCell)
    local sFlag = ""
    if bCell then
        if pElem:has_flag(RSolver.AP_CELL_ASSIGN) then
            sFlag = sFlag .. "A"
        end
        if pElem:has_flag(RSolver.AP_CELL_STRIKE) then
            sFlag = sFlag .. "S"
        end
    else
        if pElem:has_flag(RSolver.AP_SEQUENCE_TICK) then
            sFlag = sFlag .. "t"
        end
        if pElem:has_flag(RSolver.AP_SEQUENCE_STRIKE) then
            sFlag = sFlag .. "s"
        end
        if pElem:has_flag(RSolver.AP_SEQUENCE_ASSIGN) then
            sFlag = sFlag .. "a"
        end
    end

    return sFlag
end

function create_assignment_table(iRows, iCols, rgpTableValues)
    local pTable = init_table(iRows, iCols, rgpTableValues)
    assemble_agent_task_table(pTable)

    normalize_table(pTable)
    init_table_metadata(pTable)

    return pTable
end
