--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("solver.assignment.constant")
require("solver.assignment.structs.cell")
require("solver.assignment.structs.sequence")
require("utils.procedure.unpack")
require("utils.struct.class")

CApTable = createClass({
    rgpTable = {},
    rgpRows = {},
    rgpCols = {},
    iAgents = 0,
    iTasks = 0,
    iUnassigned = 0
})

function CApTable:_create_cell(iVal, iRowIdx, iColIdx)
    return CApTableCell:new({iValue = iVal, iCol = iColIdx, iRow = iRowIdx})
end

function CApTable:_create_column()
    local m_rgpCols = self.rgpCols

    local pCol = CApTableSequence:new()
    table.insert(m_rgpCols, pCol)

    return pCol
end

function CApTable:set_columns(iCols)
    clear_table(self.rgpCols)

    for i = 1, iCols, 1 do
        self:_create_column()
    end
end

function CApTable:add_column(rgValues)
    local m_rgpTable = self.rgpTable
    local m_rgpCols = self.rgpCols

    local nValues = #rgValues
    local iCol = #m_rgpCols + 1
    for iRow = 1, nValues, 1 do
        local rgpRowValues = m_rgpTable[iRow]
        table.insert(rgpRowValues, self:_create_cell(rgValues[iCol], iRow, iCol))
    end

    self:_create_column()
end

function CApTable:get_column(iIdx)
    local m_rgpCols = self.rgpCols
    return m_rgpCols[iIdx]
end

function CApTable:add_row(iAgentid, rgValues)
    local m_rgpTable = self.rgpTable
    local m_rgpRows = self.rgpRows

    local iRow = #m_rgpRows + 1

    local rgpCells = {}
    table.insert(m_rgpTable, rgpCells)

    local nValues = #rgValues
    for iCol = 1, nValues, 1 do
        table.insert(rgpCells, self:_create_cell(rgValues[iCol], iRow, iCol))
    end

    local pRow = CApTableSequence:new({iAgentid = iAgentid})
    table.insert(m_rgpRows, pRow)
end

function CApTable:get_row(iIdx)
    local m_rgpRows = self.rgpRows
    return m_rgpRows[iIdx]
end

function CApTable:get_rows()
    return self.rgpRows
end

function CApTable:get_num_rows()
    return #self.rgpRows
end

function CApTable:get_row_elements(pRow, bOmit)
    local rgpCells = {}

    local m_rgpTable = self.rgpTable
    local iIdx = (type(pRow) == "table") and pRow:get_index() or pRow
    local rgpRow = m_rgpTable[iIdx]

    local nCols = self:get_num_columns()
    for i = 1, nCols, 1 do
        local pCell = rgpRow[i]
        if not (pCell:has_flag(RSolver.AP_CELL_STRIKE) and bOmit) then
            table.insert(rgpCells, pCell)
        end
    end

    return rgpCells
end

function CApTable:get_row_values(pRow)
    local rgiVals = {}
    for _, pCell in ipairs(self:get_row_elements(pRow)) do
        table.insert(rgiVals, pCell:get_value())
    end

    return rgiVals
end

function CApTable:adjust_row_values(pRow, iValAdd)
    local iIdx = (type(pRow) == "table") and pRow:get_index() or pRow

    local m_rgpTable = self.rgpTable
    local rgpRow = m_rgpTable[iIdx]

    local nCols = self:get_num_columns()
    for i = 1, nCols, 1 do
        local pCell = rgpRow[i]
        pCell:adjust_value(iValAdd)
    end
end

function CApTable:get_columns()
    return self.rgpCols
end

function CApTable:get_num_columns()
    return #self.rgpCols
end

function CApTable:get_column_elements(pCol)
    local rgpCells = {}

    local m_rgpTable = self.rgpTable
    local iIdx = (type(pCol) == "table") and pCol:get_index() or pCol
    local nRows = self:get_num_rows()
    for i = 1, nRows, 1 do
        local rgpRow = m_rgpTable[i]
        table.insert(rgpCells, rgpRow[iIdx])
    end

    return rgpCells
end

function CApTable:get_column_values(pCol)
    local rgiVals = {}
    for _, pCell in ipairs(self:get_column_elements(pCol)) do
        table.insert(rgiVals, pCell:get_value())
    end

    return rgiVals
end

function CApTable:adjust_column_values(pCol, iValAdd)
    local iIdx = (type(pCol) == "table") and pCol:get_index() or pCol

    local m_rgpTable = self.rgpTable
    local nRows = self:get_num_rows()
    for i = 1, nRows, 1 do
        local rgpRow = m_rgpTable[i]

        local pCell = rgpRow[iIdx]
        pCell:adjust_value(iValAdd)
    end
end

function CApTable:get_cell(pRow, pCol)
    local iColIdx = (type(pCol) == "table") and pCol:get_index() or pCol
    local iRowIdx = (type(pRow) == "table") and pRow:get_index() or pRow

    local m_rgpTable = self.rgpTable
    return m_rgpTable[iRowIdx][iColIdx]
end

function CApTable:get_num_agents()
    return self.iAgents
end

function CApTable:set_num_agents(iAgents)
    self.iAgents = iAgents
end

function CApTable:get_num_tasks()
    return self.iTasks
end

function CApTable:set_num_tasks(iTasks)
    self.iTasks = iTasks
end

function CApTable:get_unassigned_count()
    return self.iUnassigned
end

function CApTable:set_unassigned_count(iCount)
    self.iUnassigned = iCount
end

function CApTable:add_unassigned_count(iCount)
    self.iUnassigned = self.iUnassigned + iCount
end

function CApTable:debug_assignment_table()
    local pTable = self

    local st = "\t|| "
    for _, pCol in pairs(pTable:get_columns()) do
        st = st .. pCol:get_index() .. "\t| "
    end
    print(st)
    print("==================== Values ========================")

    for _, pRow in pairs(pTable:get_rows()) do
        local st = ""
        st = st .. "#" .. pRow:get_index() .. "\t|| "

        for _, pCell in pairs(pTable:get_row_elements(pRow)) do
            st = st .. pCell:get_value() .. "\t| "
        end
        print(st)
    end

    print()
    print("===================== Flags ========================")

    local st = "\t|| "
    for _, pCol in pairs(pTable:get_columns()) do
        st = st .. debug_flag_value(pCol, false) .. "\t| "
    end
    print(st)
    print("====================================================")

    for _, pRow in pairs(pTable:get_rows()) do
        local st = ""
        st = st .. "#" .. debug_flag_value(pRow, false) .. "\t|| "

        for _, pCell in pairs(pTable:get_row_elements(pRow)) do
            st = st .. debug_flag_value(pCell, true) .. "\t| "
        end
        print(st)
    end

    print("====================================================")
    os.execute("pause")
end
