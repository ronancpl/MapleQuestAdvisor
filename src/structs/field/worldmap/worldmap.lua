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

CWorldmapRegion = createClass({
    sName,
    rgpNodes,
    rgpLinks
})

function CWorldmapRegion:get_name()
    return self.sName
end

function CWorldmapRegion:set_name(sName)
    self.sName = sName
end

function CWorldmapRegion:get_nodes()
    return self.rgpNodes
end

function CWorldmapRegion:set_nodes(rgpNodes)
    return self.rgpNodes = rgpNodes
end

function CWorldmapRegion:get_links()
    return self.rgpLinks
end

function CWorldmapRegion:set_links(rgpLinks)
    self.rgpLinks = rgpLinks
end
