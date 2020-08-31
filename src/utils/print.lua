--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

local tfn_printable = {
    ["nil"] = function (x) print("_NIL") end,
    ["boolean"] = function (x) print(x) end,
    ["number"] = function (x) print(x) end,
    ["string"] = function (x) print('"' .. x .. '"') end,
    ["userdata"] = function (x) print("_C_USERDATA") end,
    ["function"] = function (x) end,
    ["thread"] = function (x) end,
    ["table"] = function (x) print("{") for n, m in pairs(x) do print(n) print (" :: ") printable(m) end print("}") end
}

function printable(pItem)
    local fn_printable = pItem and pItem.printable

    if fn_printable == nil then
        local sType = type(pItem)
        fn_printable = tfn_printable[sType]

        if fn_printable == nil then
            return
        end
    end

    fn_printable(pItem)
end
