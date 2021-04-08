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
require("utils.provider.io.wordlist")

local function calc_token_matches(sCurInput, sCurMatch)
    if sCurMatch:find("*") ~= nil then
        return sCurMatch:len()
    end

    return sCurInput == sCurMatch and 1 or 0
end

function search_path_list_match(rgsPathInput, rgsPathMatch, iIdxInput, iIdxMatch)
    if iIdxMatch > #rgsPathMatch then
        return {U_INT_MAX}
    elseif iIdxInput > #rgsPathInput then
        return {}
    end

    local rgiCurMatches = {}

    local sCurMatch = rgsPathMatch[iIdxMatch]
    local sCurInput = rgsPathInput[iIdxInput]

    local iMatches = calc_token_matches(sCurInput, sCurMatch)
    if iMatches > 0 then
        if iMatches > 1 then
            iMatches = #rgsPathInput - iIdxInput + 1
        end

        local i = iIdxInput
        for j = i, i + iMatches - 1, 1 do
            table.insert(rgiCurMatches, j)
        end
    end

    local rgiPropMatches = {}
    local iIdxNextMatch = iIdxMatch + 1

    for _, iIdx in ipairs(rgiCurMatches) do
        local rgiNextMatches = search_path_list_match(rgsPathInput, rgsPathMatch, iIdx + 1, iIdxNextMatch)
        if #rgiNextMatches > 0 then
            table.insert(rgiPropMatches, iIdx)
        end
    end

    return rgiPropMatches
end

function match_path(sPathInput, sPathMatch)
    local rgsPathInput = split_path(sPathInput)
    local rgsPathMatch = split_path(sPathMatch)

    return search_path_list_match(rgsPathInput, rgsPathMatch, 1, 1) > 0
end
