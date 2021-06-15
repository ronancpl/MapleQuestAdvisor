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
require("router.constants.persistence")
require("utils.provider.json.decode")
require("utils.provider.json.encode")

function sleep(n)
    --os.execute("sleep " .. tonumber(n))
end

local function wait_for_hold_file_resultset()
    while true do
        local fIn = io.open("../" .. RPath.TMP_DB .. "/" .. RPersistFile.RS_JOURNAL, "r")
        if fIn == nil then
            local fOut = io.open("../" .. RPath.TMP_DB .. "/" .. RPersistFile.RS_JOURNAL, "w")
            if fOut ~= nil then
                return fOut
            end
        end

        sleep(RPersist.INTERFACE_SLEEP_MS)
    end
end

local function release_file_resultset(fOut)
    if fOut ~= nil then
        fOut:close()
    end

    os.remove("../" .. RPath.TMP_DB .. "/" .. RPersistFile.RS_JOURNAL)
end

function load_file_resultset(sFileSubpath, bEraseFile)
    local fLock = wait_for_hold_file_resultset()
    local fIn = io.open("../" .. RPath.TMP_DB .. "/" .. sFileSubpath, "r")

    local tpTable
    if fIn ~= nil then
        local sJson = fIn:read("*a")
        tpTable = decode_item(sJson)

        fIn:close()
    else
        tpTable = {}
    end

    if bEraseFile then
        os.remove("../" .. RPath.TMP_DB .. "/" .. sFileSubpath)
    end

    release_file_resultset(fLock)
    return tpTable
end

function reset_file_resultset(sFileSubpath)     -- load + erase
    return load_file_resultset(sFileSubpath, true)
end

function save_file_resultset(sFileSubpath, tpTable)
    local sFilePath = "../" .. RPath.TMP_DB .. "/" .. sFileSubpath

    local fLock = wait_for_hold_file_resultset()

    local fOut = io.open(sFilePath, "w")

    local iNil = 0
    if fOut == nil then -- really shouldn't happen
        repeat
            fOut = io.open(sFilePath, "w")
            iNil = iNil + 1
            sleep(RPersist.INTERFACE_SLEEP_MS)
        until fOut ~= nil or iNil >= 5
    end

    local sJson = encode_item(tpTable)
    fOut:write(sJson)

    fOut:close()
    release_file_resultset(fLock)
end
