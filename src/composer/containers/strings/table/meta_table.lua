--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("utils.procedure.copy")
require("utils.struct.class")

CEntryMetaTable = createClass({
    tEntryStrings = {}
})

function CEntryMetaTable:set_text(iId, ...)
    local pText = ...

    local tEntry = {}
    if type(pText) == "table" then
        table_merge(tEntry, pText)
    else
        table.insert(tEntry, pText)
    end

    self.tEntryStrings[iId] = tEntry
end

function CEntryMetaTable:get_text(iId, iPos)
    local pEntryName = self.tEntryStrings[iId]
    return pEntryName and pEntryName[iPos or 1] or ""
end
