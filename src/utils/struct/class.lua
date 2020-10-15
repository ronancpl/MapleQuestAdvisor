--[[

    This source file, based on the original implementation presented on the lua.org site, codifies class members definition
    and value initialization along the class instance.

    Usage:  CLASS_DEF = CREATE_CLASS ({CLASS_ARG_LIST})

            CLASS_ARG_LIST: (CLASS_ARG[, CLASS_ARG]*)
            CLASS_ARG: CLASS_DEF | CLASS_COMP
            CLASS_COMP: {[CLASS_MEMBER_ARG[, CLASS_MEMBER_ARG]*]}

]]--

require("utils.procedure.copy")

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
    function c:new (sv)
        sv = sv or {}

        -- load constructor values from superclass
        local nv = loadValues(sv)

        local o = {}
        setmetatable(o, c)

        -- init field values
        for k, v in pairs(c.classMembers) do
            o[deep_copy(k)] = deep_copy(v)
        end

        -- init constructor values
        for k, v in pairs(nv) do
            o[deep_copy(k)] = v
        end

        return o
    end

    -- init field values for this singleton instance
    function c:init ()
        for k, v in pairs(c.classMembers) do
            c[deep_copy(k)] = v
        end
        c.__static = true
    end

    -- return new class
    return c
end
