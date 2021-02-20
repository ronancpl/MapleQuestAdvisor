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

local bit = require("bit")

CApTableElement = createClass({
    siFlag = 0
})

function CApTableElement:clear_flag()
    self.siFlag = 0
end

function CApTableElement:_flag_disable(siFlagType)
    self.siFlag = bit.band(self.siFlag, U_INT_MAX - bit.lshift(1, siFlagType))
end

function CApTableElement:_flag_enable(siFlagType)
    self.siFlag = bit.bor(self.siFlag, bit.lshift(1, siFlagType))
end

function CApTableElement:set_flag(siFlagType, bActive)
    if bActive then
        self:_flag_enable(siFlagType)
    else
        self:_flag_disable(siFlagType)
    end
end

function CApTableElement:has_flag(siFlagType)
    return bit.band(self.siFlag, bit.lshift(1, siFlagType)) ~= 0
end
