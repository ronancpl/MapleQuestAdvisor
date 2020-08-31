-- look up for `k' in list of tables `plist'
local function search (k, plist)
    for i=1, table.getn(plist)
    do
        local v = plist[i][k]     -- try
        -- `i'-th superclass
        if v then return v end
    end
end

function deepCopy(e)
    local ce
    if type(e) == "table" then
        ce = {}
        for k, v in pairs(e) do
            ce[deepCopy(k)] = deepCopy(v)
        end
        setmetatable(ce, getmetatable(e))
    else
        ce = e  -- string, number, etc
    end

    return ce
end

function createClass (...)
    local c = {}        -- new class

    c.classMembers = {} -- members definition
    for k, v in pairs(...) do
        c.classMembers[k] = v
    end

    -- class will search for each method in the list of its
    -- parents (`arg' is the list of parents)
    setmetatable(c,
    {
        __index = function (t, k)
            local arg = c.classMembers
            return search(k, arg)
        end
    })

    -- prepare `c' to be the metatable of its instances
    c.__index = c

    -- define a new constructor for this new class
    function c:new (o)
        o = o or {}
        setmetatable(o, c)

        -- init field values
        for k, v in pairs(c.classMembers) do
            o[k] = deepCopy(v)
        end

        return o
    end

    -- init field values for this singleton instance
    function c:init ()
        for k, v in pairs(c.classMembers) do
            c[k] = deepCopy(v)
        end
        c.__static = true
    end

    -- return new class
    return c
end
