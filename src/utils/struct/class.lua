--[[

    This source file, based on the original implementation presented on the lua.org site, codifies class members definition
    and value initialization along the class instance.

    Usage:  CLASS_DEF = CREATE_CLASS ({CLASS_ARG_LIST})

            CLASS_ARG_LIST: (CLASS_ARG[, CLASS_ARG]*)
            CLASS_ARG: CLASS_DEF | CLASS_COMP
            CLASS_COMP: {[CLASS_MEMBER_ARG[, CLASS_MEMBER_ARG]*]}

]]--

require("utils.procedure.copy")

local function assignClassMethods(o)
    local m = o.classMethods
    if m ~= nil then
        for sName, pMember in pairs(m) do
            o[sName] = pMember
        end
    end
end

local function unassignClassMethods(o)
    local m = o.classMethods
    if m ~= nil then
        for sName, _ in pairs(m) do
            o[sName] = nil
        end
    end
end

local function getMetatableMethods(o, m)
    for sName, pMember in pairs(o) do
        if type(pMember) == "function" then
            m[sName] = pMember
        end
    end
end

function clearClassMethods(o)
    unassignClassMethods(o)

    o.classMethods = nil
    o.classMembers.hasClassMethods = false
end

function getClassMethods(o)
    local b = o.classMembers.hasClassMethods

    local m
    if not b then
        m = {}
        getMetatableMethods(getmetatable(o), m)
        getMetatableMethods(o, m)
        for _, c in ipairs(o.classAncestors) do
            getMetatableMethods(c, m)
        end

        o.classMethods = m
        o.classMembers.hasClassMethods = true

        assignClassMethods(o)
    else
        m = o.classMethods
    end

    return m
end

function reloadClassMethods(o)
    clearClassMethods(o)
    getClassMethods(o)
end

local function retrieveClassMembers(c)
    local retMembers = {}

    local classMembers = c.classMembers
    local innerMembers = classMembers["classMembers"]
    if innerMembers ~= nil then
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

local function insertClassInheritance(retSubclasses, c)
    if c.classMembers ~= nil then
        table.insert(retSubclasses, c)
    end
end

local function initClassMembers(...)
    local retMembers = {}                    -- raw members definition
    local retSubclasses = {}

    retMembers.hasClassMethods = false

    if #... > 0 then
        for _, c in ipairs(...) do
            local cMembers = initClassMembersInternal(c)
            insertClassMembers(retMembers, cMembers)
            insertClassInheritance(retSubclasses, c)
        end
    else
        local cMembers = initClassMembersInternal(...)
        insertClassMembers(retMembers, cMembers)
    end

    return retMembers, retSubclasses
end

local function loadValues(o)
    local nv = {}
    for k, v in pairs(o) do
        nv[k] = v
    end

    return nv
end

local function fn_index(tObj, sName)
    local classMembers = tObj.classMembers
    return classMembers[sName] or (classMembers.hasClassMethods and tObj.classMethods[sName]) or nil
end

function createClass (...)
    local c = {}        -- new class

    -- prepare `c' to be the metatable of its instances
    setmetatable(c, {__index = fn_index})
    c.__index = c

    c.classMembers, c.classAncestors = initClassMembers(...)
    c.classMembers = retrieveClassMembers(c) -- members definition

    -- define a new constructor for this new class
    function c:_init (sv)
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

    -- externalize constructor method, custom-constructor classes needs to call _init
    function c:new (sv)
        return c:_init (sv)
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
