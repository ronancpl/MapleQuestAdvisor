--[[

    This source file, based on the original implementation presented on the lua.org site, codifies class members definition
    and value initialization along the class instance.

    Usage:  CLASS_DEF = CREATE_CLASS ({CLASS_ARG_LIST})

            CLASS_ARG_LIST: (CLASS_ARG[, CLASS_ARG]*)
            CLASS_ARG: CLASS_DEF | CLASS_COMP
            CLASS_COMP: {[CLASS_MEMBER_ARG[, CLASS_MEMBER_ARG]*]}

]]--

local function deepCopy(e)
    local ce
    if type(e) == "table" then
        ce = {}
        for k, v in pairs(e) do
            local ck = k ~= e and deepCopy(k) or k
            local cv = v ~= e and deepCopy(v) or v
            ce[ck] = cv
        end
        setmetatable(ce, getmetatable(e))
    else
        ce = e  -- string, number, etc
    end

    return ce
end

local function retrieveClassMembers(c)
    local retMembers = {}

    local classMembers = c.classMembers
    local innerMembers = classMembers["classMembers"]
    if (innerMembers ~= nil) then
        for k, v in pairs(retrieveClassMembers(classMembers)) do
            retMembers[k] = v
        end
    end

    for k, v in pairs(classMembers) do
        retMembers[k] = v
    end

    return retMembers
end

local function initClassMembersInternal(tClassMembers)
    local retMembers = {}                    -- raw members definition
    for k, v in pairs(tClassMembers) do
        retMembers[k] = v
    end

    return retMembers
end

local function insertClassMembers(retMembers, classMembers)
    for k, v in pairs(classMembers) do
        retMembers[k] = v
    end
end

local function initClassMembers(...)
    local retMembers = {}                    -- raw members definition

    if (#... > 0) then
        for _, c in ipairs(...) do
            local cMembers = initClassMembersInternal(c)
            insertClassMembers(retMembers, cMembers)
        end
    else
        local cMembers = initClassMembersInternal(...)
        insertClassMembers(retMembers, cMembers)
    end

    return retMembers
end

local function loadValues(o)
    local nv = {}
    for k, v in pairs(o) do
        nv[k] = v
    end

    return nv
end

function createClass (...)
    local c = {}        -- new class

    c.classMembers = initClassMembers(...)
    c.classMembers = retrieveClassMembers(c) -- members definition

    -- prepare `c' to be the metatable of its instances
    setmetatable(c, {__index = c.classMembers})
    c.__index = c

    -- define a new constructor for this new class
    function c:new (o)
        o = o or {}
        setmetatable(o, c)

        -- load constructor values
        local nv = loadValues(o)

        -- init field values
        for k, v in pairs(c.classMembers) do
            o[deepCopy(k)] = deepCopy(v)
        end

        -- init constructor values
        for k, v in pairs(nv) do
            o[deepCopy(k)] = deepCopy(v)
        end

        return o
    end

    -- init field values for this singleton instance
    function c:init ()
        for k, v in pairs(c.classMembers) do
            c[deepCopy(k)] = deepCopy(v)
        end
        c.__static = true
    end

    -- return new class
    return c
end
