--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("router.filters.constant")
require("solver.assignment.constant")
require("solver.assignment.procedures.create")
require("utils.struct.class")

local function get_table_dimensions(rgpTableValues)
    local iRows = U_INT_MAX
    local iCols = #rgpTableValues

    for _, rgiRow in ipairs(rgpTableValues) do
        local nRow = #rgiRow
        if nRow < iRows then
            nRow = iRows
        end
    end

    return iRows, iCols
end

local function fetch_min_value(rgiVals)
    local iRet = U_INT_MAX

    for _, iVal in ipairs(rgiVals) do
        if iVal < iRet then
            iRet = iVal
        end
    end

    return iRet
end

local function get_oct_each_min_row_element(pTable)
    local rgiMinVals = {}

    for _, pRow in ipairs(pTable:get_rows()) do
        local rgiVals = pTable:get_row_values(pRow)

        local iMinVal = fetch_min_value(rgiVals)
        table.insert(rgiMinVals, iMinVal)
    end

    return rgiMinVals
end

local function reduce_oct_row_elements(pTable, rgiMinVals)
    local rgpRows = pTable:get_rows()
    local nRows = #rgpRows
    for i = 1, nRows, 1 do
        local pRow = rgpRows[i]
        pTable:adjust_row_values(pRow, -1 * rgiMinVals[i])
    end
end

local function reduce_oct_rows(pTable)
    local rgiMinVals = get_oct_each_min_row_element(pTable)
    reduce_oct_row_elements(pTable, rgiMinVals)
end

local function get_oct_each_min_column_element(pTable)
    local rgiMinVals = {}

    for _, pCol in ipairs(pTable:get_columns()) do
        local rgiVals = pTable:get_column_values(pCol)

        local iMinVal = fetch_min_value(rgiVals)
        table.insert(rgiMinVals, iMinVal)
    end

    return rgiMinVals
end

local function reduce_oct_column_elements(pTable, rgiMinVals)
    local rgpCols = pTable:get_rows()
    local nCols = #rgpCols
    for i = 1, nCols, 1 do
        local pCol = rgpCols[i]
        pTable:adjust_column_values(pCol, -1 * rgiMinVals[i])
    end
end

local function reduce_oct_columns(pTable)
    local rgiMinVals = get_oct_each_min_column_element(pTable)
    reduce_oct_column_elements(pTable, rgiMinVals)
end

local function reset_oct_row_assigned(pTable)
    local rgpCols = pTable:get_columns()
    for _, pCol in ipairs(rgpCols) do
        pCol:flag_set(RSolver.AP_SEQUENCE_ASSIGN, false)
    end

    local rgpRows = pTable:get_rows()
    for _, pRow in ipairs(rgpRows) do
        pRow:flag_set(RSolver.AP_SEQUENCE_ASSIGN, false)
    end
end

local function examine_oct_assignable_row(pTable, iIdx)
    local iAssignableIdx = nil

    local pRow = pTable:get_row(iIdx)
    if not pRow:has_flag(RSolver.AP_SEQUENCE_ASSIGN) then
        local rgpRowCells = pTable:get_row_elements(pRow, true)
        for _, pCell in ipairs(rgpRowCells) do
            if pCell:get_value() == 0 then
                if iAssignableIdx ~= nil then
                    iAssignableIdx = nil    -- second zero has been found
                    break
                else
                    iAssignableIdx = pCell:get_column()
                end
            end
        end
    end

    return iAssignableIdx
end

local function strike_list_zeros_on_oct_assignment(rgpCells)
    for _, pCell in ipairs(rgpCells) do
        local iVal = pCell:get_value()
        if iVal == 0 then
            pCell:set_flag(RSolve.AP_CELL_STRIKE, true)
        end
    end
end

local function cross_list_zeros_on_oct_assignment(pTable, pCell)
    local rgpRowCells = pCell:get_row_elements(pCell:get_row())
    local rgpColCells = pCell:get_column_elements(pCell:get_column())

    strike_list_zeros_on_oct_assignment(rgpRowCells)
    strike_list_zeros_on_oct_assignment(rgpColCells)
end

local function examine_oct_assign_cell(rgpCellsAssigned, iRowIdx, iColIdx)
    local pCell = pTable:get_cell(iRowIdx, iColIdx)
    pCell:set_flag(RSolver.AP_CELL_ASSIGN, true)

    table.insert(rgpCellsAssigned, pCell)
end

local function cross_list_oct_assigned_cells(pTable, rgpCellsAssigned)
    for _, pCell in ipairs(rgpCellsAssigned) do
        pTable:add_unassigned_count(-1)

        cross_list_zeros_on_oct_assignment(pTable, pCell)

        local pCol = pTable:get_column(pCell:get_column())
        pCol:set_flag(RSolver.AP_SEQUENCE_ASSIGN, true)

        local pRow = pTable:get_row(pCell:get_row())
        pRow:set_flag(RSolver.AP_SEQUENCE_ASSIGN, true)
    end
end

local function assign_on_multi_arbitrarily_oct_assignment(pTable)
    local rgpCellsAssigned = {}

    for _, pRow in ipairs(pTable:get_rows()) do
        if not pRow:has_flag(RSolver.AP_SEQUENCE_ASSIGN) then
            local rgpCells = pTable:get_row_elements(pRow, true)
            for _, pCell in ipairs(rgpCells) do
                if pCell:get_value() == 0 then
                    examine_oct_assign_cell(rgpCellsAssigned, pCell:get_row(), pCell:get_column())
                    table.insert(rgpCellsAssigned, pCell)

                    break
                end
            end

            break   -- one per time
        end
    end

    cross_list_oct_assigned_cells(pTable, rgpCellsAssigned)
end

local function examine_oct_assignments(pTable)
    reset_oct_row_assigned(pTable)

    local nCols = pTable:get_num_cols()
    local nRows = pTable:get_num_rows()

    pTable:set_unassigned_count(nCols)
    while true do
        local rgpCellsAssigned = {1}
        while #rgpCellsAssigned > 0 do
            rgpCellsAssigned = {}

            for iRowIdx = 1, nRows, 1 do
                local iAsgnColIdx = examine_oct_assignable_row(pTable, iRowIdx)
                if iAsgnColIdx ~= nil then
                    examine_oct_assign_cell(rgpCellsAssigned, iRowIdx, iAsgnColIdx)
                end
            end

            cross_list_oct_assigned_cells(pTable, rgpCellsAssigned)
        end

        if pTable:get_unassigned_count() == 0 then
            break
        end

        assign_on_multi_arbitrarily_oct_assignment(pTable)
    end
end

local function find_opportunity_cost_table(pTable)
    reduce_oct_rows(pTable)
    reduce_oct_columns(pTable)

    examine_oct_assignments(pTable)
end

local function is_sequence_with_assigned_zero(rgpCells)
    for _, pCell in ipairs(rgpCells) do
        if pCell:has_flag(RSolver.AP_CELL_ASSIGN) then
            return true
        end
    end

    return false
end

local function fetch_rows_no_zero_oct_revise(pTable)
    local rgpRows = {}

    for _, pRow in ipairs(pTable:get_rows()) do
        if not is_sequence_with_assigned_zero(pTable:get_row_elements(pRow)) then
            table.insert(rgpRows, pRow)
        end
    end

    return rgpRows
end

local function fetch_columns_with_zero_oct_revise(pTable)
    local rgpCols = {}

    for _, pCol in ipairs(pTable:get_columns()) do
        if is_sequence_with_assigned_zero(pTable:get_column_elements(pCol)) then
            table.insert(rgpCols, pCol)
        end
    end

    return rgpCols
end

local function fetch_columns_zero_oct_revise(pTable)
    for _, pCol in ipairs(pTable:get_columns()) do
        if not pRow:has_flag(RSolver.AP_SEQUENCE_ASSIGN) then
            pRow:set_flag(RSolver.AP_SEQUENCE_TICK, true)
        end
    end
end

local function find_zero_in_sequence(pTable, rgpCells)
    local rgpCells = {}

    for _, pCell in ipairs(rgpCells) do
        local iVal = pCell:get_value()
        if iVal == 0 then
            table.insert(rgpCells, pCell)
        end
    end

    return rgpCells
end

local function examine_rows_zero_oct_revise(pTable, rgpUasgnRows)
    local rgpRows = rgpUasgnRows
    for _, pRow in ipairs(rgpRows) do
        pRow:set_flag(RSolver.AP_SEQUENCE_TICK, true)
    end

    while #rgpRows > 0 do
        local rgpNextRows = {}

        for _, pRow in ipairs(rgpRows) do
            for _, pRowCell in ipairs(pTable:get_row_elements(pRow)) do
                local iColIdx = pRowCell:get_column()
                local pCurCol = pTable:get_column(iColIdx)

                if not pCurCol:has_flag(RSolver.AP_SEQUENCE_TICK) then
                    pCurCol:set_flag(RSolver.AP_SEQUENCE_TICK, true)

                    local rgpColCells = pTable:get_column_elements(pCurCol)
                    local rgpCells = find_zero_in_sequence(pTable, rgpColCells)
                    for _, pCell in ipairs(rgpCells) do
                        local iCurRowIdx = pCell:get_row()
                        local pCurRow = pTable:get_row(iCurRowIdx)

                        if not pCurRow:has_flag(RSolver.AP_SEQUENCE_TICK) then
                            pCurRow:set_flag(RSolver.AP_SEQUENCE_TICK, true)
                            table.insert(rgpNextRows, pCurRow)
                        end
                    end
                end
            end
        end

        rgpRows = rgpNextRows
    end
end

local function tick_rows_not_assigned_oct_revise(pTable)
    local rgpRows = {}

    for _, pRow in ipairs(pTable:get_rows()) do
        if not pRow:has_flag(RSolver.AP_SEQUENCE_ASSIGN) then
            pRow:set_flag(RSolver.AP_SEQUENCE_TICK, true)
            table.insert(rgpRows, pRow)
        end
    end

    return rgpRows
end

local function fiddle_revised_oct_headers(pTable)
    local iLineCol = 0
    local iLineRow = 0

    for _, pCol in ipairs(pTable:get_columns()) do
        if pCol:has_flag(RSolver.AP_SEQUENCE_TICK) then
            pCol:set_flag(RSolver.AP_SEQUENCE_STRIKE, true)
            iLineCol = iLineCol + 1
        end
    end

    for _, pRow in ipairs(pTable:get_rows()) do
        if not pRow:has_flag(RSolver.AP_SEQUENCE_TICK) then
            pRow:set_flag(RSolver.AP_SEQUENCE_STRIKE, true)
            iLineRow = iLineRow + 1
        end
    end

    return iLineCol == iLineRow
end

local function find_shortest_revised_oct_value(pTable)
    local iRet = U_INT_MAX

    for _, pRow in ipairs(pTable:get_rows()) do
        if not pRow:has_flag(RSolver.AP_SEQUENCE_STRIKE) then
            for _, pCell in ipairs(pTable:get_row_elements(pRow)) do
                local iColIdx = pCell:get_column()

                local pCol = pTable:get_column(iColIdx)
                if not pCol:has_flag(RSolver.AP_SEQUENCE_STRIKE) then
                    local iVal = pCell:get_value()
                    if iVal < iRet then
                        iRet = iVal
                    end
                end
            end
        end
    end

    return iRet
end

local function fetch_coverage_on_oct_headers(pTable)
    local rgpNoneCells = {}
    local rgpDoubleCells = {}

    for _, pRow in ipairs(pTable:get_rows()) do
        for _, pCell in ipairs(pTable:get_row_elements(pRow)) do
            local iColIdx = pCell:get_column()
            local pCol = pTable:get_column(iColIdx)

            local bColCover = pCol:has_flag(RSolver.AP_SEQUENCE_STRIKE)
            local bRowCover = pRow:has_flag(RSolver.AP_SEQUENCE_STRIKE)

            if bColCover then
                if bRowCover then
                    table.insert(rgpDoubleCells, pCell)
                end
            else
                if not bRowCover then
                    table.insert(rgpNoneCells, pCell)
                end
            end

        end
    end

    return rgpNoneCells, rgpDoubleCells
end

local function apply_revised_oct_headers(pTable)
    local iVal = find_shortest_revised_oct_value(pTable)

    local rgpNoneCells
    local rgpDoubleCells
    rgpNoneCells, rgpDoubleCells = fetch_coverage_on_oct_headers(pTable)

    for _, pCell in ipairs(rgpNoneCells) do
        pCell:adjust_value(-iVal)
    end

    for _, pCell in ipairs(rgpDoubleCells) do
        pCell:adjust_value(iVal)
    end
end

local function revise_oct_contents(pTable)
    while true do
        local rgpUasgnRows = tick_rows_not_assigned_oct_revise(pTable)
        examine_rows_zero_oct_revise(pTable, rgpUasgnRows)
        examine_rows_zero_oct_revise(pTable)

        local bFinished = fiddle_revised_oct_headers(pTable)
        if bFinished then
            return
        end

        apply_revised_oct_headers(pTable)
    end
end

local function collect_assigned_agent_tasks(pTable)
    local trgiAgentTasks = {}

    for _, pRow in ipairs(pTable:get_rows()) do
        for _, pCell in ipairs(pTable:get_row_elements(pRow)) do
            if pCell:has_flag(RSolver.AP_CELL_ASSIGN) then
                local iColIdx = pCell:get_column()

                local iTaskid = iColIdx
                local iAgentid = pRow:get_agent_id()

                local rgiTasks = trgiAgentTasks[iAgentid]
                table.insert(rgiTasks, iTaskid)
            end
        end
    end

    return trgiAgentTasks
end

local function solve_assignment_case(iRows, iCols, rgpTableValues)
    local pTable = create_assignment_table(iRows, iCols, rgpTableValues)    -- initializes opportunity cost table
    revise_oct_contents(pTable)

    local trgiAgentTasks = collect_assigned_agent_tasks(pTable)
    return trgiAgentTasks
end

function run_assignment_case(rgpTableValues)
    local iRows
    local iCols
    iRows, iCols = get_table_dimensions(rgpTableValues)

    local trgiAgentTasks = solve_assignment_case(iRows, iCols, rgpTableValues)
    return trgiAgentTasks
end
