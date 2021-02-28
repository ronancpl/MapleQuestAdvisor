--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("ui.struct.worldmap.basic.spot")
require("utils.struct.class")

CWmapNodeMarker = createClass({CWmapBasicSpot, {
    pImgPath,
    pNodeMapno,
    pNodeTextbox,
    iType
}})

function CWmapNodeMarker:get_path()
    return self.pImgPath
end

function CWmapNodeMarker:set_path(pImgPath)
    self.pImgPath = pImgPath
end

function CWmapNodeMarker:get_mapno()
    return self.pNodeMapno
end

function CWmapNodeMarker:set_mapno(pNodeMapno)
    self.pNodeMapno = pNodeMapno
end

function CWmapNodeMarker:get_textbox()
    return self.pNodeTextbox
end

function CWmapNodeMarker:set_textbox(pNodeTextbox)
    self.pNodeTextbox = pNodeTextbox
end

function CWmapNodeMarker:get_type()
    return self.iType
end

function CWmapNodeMarker:set_type(iType)
    self.iType = iType
end

function CWmapNodeMarker:new(iOx, iOy)
    self.iOx = iOx
    self.iOy = iOy
    return self
end
