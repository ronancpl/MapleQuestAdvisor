--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("utils.class");

CFieldObject = createClass({
    iSourceid = -1,
    iCount = 0
})

function CFieldObject:get_sourceid()
    return self.iSourceid
end

function CFieldObject:set_sourceid(iSourceid)
    self.iSourceid = iSourceid
end

function CFieldObject:get_count()
    return self.iCount
end

function CFieldObject:set_count(iCount)
    self.iCount = iCount
end
