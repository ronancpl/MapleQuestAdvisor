--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("router.procedures.constant")
require("utils.struct.class")

CBasicAnima = createClass({
    iCurQuad,
    iLimQuad,
    rgpQuads
})

function CBasicAnima:set_num_frames(iFrames)
    self.iLimQuad = math.iclamp(iFrames, 1, #self.rgpQuads)
end

function CBasicAnima:load(rgpQuads)
    self.rgpQuads = rgpQuads

    self.iCurQuad = 1
    self:set_num_frames(U_INT_MAX)
end

function CBasicAnima:inspect_quad()
    return self.rgpQuads[self.iCurQuad]
end

function CBasicAnima:update_quad()
    self.iCurQuad = (self.iCurQuad % self.iLimQuad) + 1
end

function CBasicAnima:get_instant()
    return self.iCurQuad
end

function CBasicAnima:get_quads()
    return self.rgpQuads
end
