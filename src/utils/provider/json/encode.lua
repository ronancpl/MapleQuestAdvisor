--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

local json = require("json")

function encode_item(pItem)
    return json:encode({pItem})
end

function encode_stream(...)
    local rgpStream = {}
    for _, pItem in pairs(...) do
        table_append(rgpStream, pItem)
    end

    return json:encode(rgpStream)
end
