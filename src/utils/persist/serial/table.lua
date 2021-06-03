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

function load_file_resultset()
    local fIn = io.open(RPath.TMP_DB .. "/result.txt", "r")

    local sJson = fIn:read("*a")
    local tpTable = decode_stream(sJson)

    fIn:close()

    return tpTable
end

function save_file_resultset(tpTable)
    local fOut = io.open(RPath.TMP_DB .. "/result.txt", "w")

    local sJson = encode_stream(tpTable)
    fOut:write(sJson)

    fOut:close()
end
