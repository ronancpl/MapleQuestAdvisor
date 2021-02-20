--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("solver.assignment.structs.element")
require("utils.struct.class")

CApTableCell = createClass({CApTableElement, {
    iCol,
    iRow,
    iValue = 0
}})

function CApTableCell:get_column()
    return self.iCol
end

function CApTableCell:get_row()
    return self.iRow
end

function CApTableCell:get_value()
    return self.iValue
end

function CApTableCell:set_value(iVal)
    self.iValue = iVal
end

function CApTableCell:adjust_value(iValAdd)
    self.iValue = math.max(self.iValue + iValAdd, 0)
end
