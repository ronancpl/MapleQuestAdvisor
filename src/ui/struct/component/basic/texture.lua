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

CBasicOutline = createClass({
    iLx,
    iTy,
    iRy,
    iBy,
    iZ
})

function CBasicOutline:get_origin()
    return self.iLx, self.iTy
end

function CBasicOutline:get_z()
    return self.iZ
end

function CBasicOutline:get_ltrb()
    local iLx = self.iLx
    local iTy = self.iTy
    local iRx = self.iRy
    local iBy = self.iBy

    return iLx, iTy, iRx, iBy
end

function CBasicOutline:load(iOx, iOy, iZ, iW, iH)
    self.iLx = iOx
    self.iTy = iOy
    self.iRy = iOx + iW
    self.iBy = iOy + iH
    self.iZ = iZ
end
