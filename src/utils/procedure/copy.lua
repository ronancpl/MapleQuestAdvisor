--[[

    This source file, based on the original implementation presented on the lua.org site, codifies new instantiation for a table, and
    recursively for all internal tables. Other element types are passed intact.

]]--

function deep_copy(e)
    local ce
    if type(e) == "table" then
        ce = {}
        for k, v in pairs(e) do
            local ck = k ~= e and deep_copy(k) or k
            local cv = v ~= e and deep_copy(v) or v
            ce[ck] = cv
        end
        setmetatable(ce, getmetatable(e))
    else
        ce = e  -- string, number, etc
    end

    return ce
end