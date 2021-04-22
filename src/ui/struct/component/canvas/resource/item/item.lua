--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

CCanvasRscItem = createClass({
    sDesc,
    iFieldRef
})

function CCanvasRscItem:load(sDesc, iFieldRef)
    self.sDesc = sDesc
    self.iFieldRef = iFieldRef
end

function CCanvasRscItem:get_desc()
    return self.sDesc
end

function CCanvasRscItem:get_field_link()
    return self.iFieldRef
end
