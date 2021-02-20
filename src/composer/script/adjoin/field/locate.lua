--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

local function locate_script_resource_event(sSrcid)
    local sEventName = sSrcid
    local rgiMapids = ctExEvents:get_locations(sEventName)

    return rgiMapids
end

local function locate_script_resource_map(iSrcid)
    local iMapid = iSrcid
    local rgiMapids = {iMapid}

    return rgiMapids
end

local function locate_script_resource_npc(iSrcid)
    local iNpcid = iSrcid
    local rgiMapids = ctNpcs:get_locations(iNpcid)

    return rgiMapids
end

local function locate_script_resource_portal(sSrcid)
    local sPortalName = sSrcid
    local rgiMapids = ctExPortals:get_locations(sPortalName)

    return rgiMapids
end

local function locate_script_resource_reactor(iSrcid)
    local iReactorid = iSrcid
    local rgiMapids = ctReactors:get_locations(iReactorid)

    return rgiMapids
end

function fetch_table_directory_append_method()
    local tfn_dir_locate = {}

    tfn_dir_locate["event"] = locate_script_resource_event
    tfn_dir_locate["map"] = locate_script_resource_map
    tfn_dir_locate["npc"] = locate_script_resource_npc
    tfn_dir_locate["portal"] = locate_script_resource_portal
    tfn_dir_locate["reactor"] = locate_script_resource_reactor

    return tfn_dir_locate
end

function fetch_table_directory_append_container()
    local tfn_dir_ct = {}

    tfn_dir_ct["SpawnMob"] = ctMobs
    tfn_dir_ct["SpawnNpc"] = ctNpcs

    return tfn_dir_ct
end
