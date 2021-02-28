--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("utils.struct.class")

CWmapNodeLink = createClass({
    pNodeLinkImg,
    sLinkMap
})

function CWmapNodeLink:get_link_image()
    return self.pNodeLinkImg
end

function CWmapNodeLink:set_link_image(pNodeLinkImg)
    self.pNodeLinkImg = pNodeLinkImg
end

function CWmapNodeLink:get_link_map()
    return self.sLinkMap
end

function CWmapNodeLink:set_link_map(sLinkMap)
    self.sLinkMap = sLinkMap
end
