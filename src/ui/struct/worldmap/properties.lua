--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("utils.procedure.unpack")
require("utils.struct.class")

CWmapProperties = createClass({
    sParentMap,
    pBaseImg,
    rgpMapList,
    rgpMapLink
})

function CWmapProperties:reset()
    self.sParentMap = nil
    self.pBaseImg = nil
    clear_table(self.rgpMapList)
    clear_table(self.rgpMapLink)
end

function CWmapProperties:set_parent_map(sParentMap)
    self.sParentMap = sParentMap
end

function CWmapProperties:set_base_img(pBaseImg)
    self.pBaseImg = pBaseImg
end

function CWmapProperties:add_map_link(pRegionLink)
    table.insert(self.rgpMapLink, pRegionLink)
end

function CWmapProperties:load_map_field(pFieldNode)
    table.insert(self.rgpMapLink, pFieldNode)
end

function CWmapProperties:load()

    load_worldmap()


end
