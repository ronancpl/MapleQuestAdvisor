--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("router.constants.path")
require("utils.provider.json.decode")
require("utils.provider.json.encode")

function load_file_resultset(sFileSubpath)
    local fIn = io.open("../" .. RPath.TMP_DB .. "/" .. sFileSubpath, "r")

    local tpTable
    if fIn ~= nil then
        local sJson = fIn:read("*a")
        tpTable = decode_item(sJson)

        fIn:close()
    else
        tpTable = {}
    end

    return tpTable
end

function save_file_resultset(sFileSubpath, tpTable)
    local fOut = io.open("../" .. RPath.TMP_DB .. "/" .. sFileSubpath, "w")

    local sJson = encode_item(tpTable)
    fOut:write(sJson)

    fOut:close()
end
