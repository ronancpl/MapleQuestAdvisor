--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("utils.struct.class")

CWorldmapNode = createClass({
    sTitle,
    sDesc,
    rgiMapNo
})

function CWorldmapNode:get_description()
    return self.sDesc
end

function CWorldmapNode:set_description(sDesc)
    self.sDesc = sDesc
end

function CWorldmapNode:get_title()
    return self.sTitle
end

function CWorldmapNode:set_title(sTitle)
    self.sTitle = sTitle
end

function CWorldmapNode:get_mapno_list()
    return self.rgiMapNo
end

function CWorldmapNode:set_mapno_list(rgiMapNo)
    self.rgiMapNo = rgiMapNo
end
