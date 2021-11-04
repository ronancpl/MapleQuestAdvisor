--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("utils.procedure.copy")
require("utils.struct.class")

CMediaTable = createClass({
    sBasePath,
    sPrependImgPath = "",
    tpItems     -- keys: relative subpaths after base path
})

function CMediaTable:get_path()
    return self.sBasePath
end

function CMediaTable:set_path(sPath)
    self.sBasePath = sPath
end

function CMediaTable:get_contents()
    return self.tpItems
end

function CMediaTable:set_contents(tpItems)
    self.tpItems = tpItems
end

function CMediaTable:get_prepend()
    return self.sPrependImgPath
end

function CMediaTable:set_prepend(sPrepend)
    self.sPrependImgPath = sPrepend
end

function CMediaTable:clone()
    local pDirMedia = CMediaTable:new()

    pDirMedia:set_path(deep_copy(self:get_path()))
    pDirMedia:set_contents(deep_copy(self:get_contents()))
    pDirMedia:set_prepend(deep_copy(self:get_prepend()))

    return pDirMedia
end
