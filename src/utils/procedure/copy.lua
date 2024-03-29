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

function table_copy(e)
    local ce
    if type(e) == "table" then
        ce = {}
        for k, v in pairs(e) do
            ce[k] = v
        end
        setmetatable(ce, getmetatable(e))
    else
        ce = e  -- string, number, etc
    end

    return ce
end

function table_merge(tDest, tOrig)
    for k, v in pairs(tOrig) do
        tDest[k] = v
    end
end

function table_append(rgDest, tOrig)
    for _, v in pairs(tOrig) do
        table.insert(rgDest, v)
    end
end

function table_intersection(tTable, tOther)
    local tItrs = {}
    for k, v in pairs(tTable) do
        if tOther[k] == nil then
            tItrs[k] = v
        end
    end

    return tItrs
end

function table_select(tTable, rgKeys)
    local tDest = {}
    for _, k in ipairs(rgKeys) do
        tDest[k] = tTable[k]
    end

    return tDest
end

local function table_tostring_internal(e)
    local st = ""

    if type(e) == "table" then
        for k, v in pairs(e) do
            local ck = k ~= e and table_tostring(k) or tostring(k)
            local cv = v ~= e and table_tostring(v) or tostring(v)
            st = st .. ck .. ":" .. cv .. ", "
        end
    else
        st = st .. tostring(e)  -- string, number, etc
    end

    return st
end

function table_tostring(e)
    local st

    if type(e) == "table" then
        st = "{" .. table_tostring_internal(e):sub(1, -3) .. "}"
    else
        st = table_tostring_internal(e)
    end

    return st
end
