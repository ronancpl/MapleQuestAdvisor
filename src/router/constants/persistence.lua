--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

RPersistPath = {

    DB = "data.db",

    RATES = "field_rates",
    STAT = "character_info",
    INVENTORY = "character_inventory"

}

RPersistKey = {

    DEFAULT = 1

}

RPersistTable = {   -- first element as primary key

    RATES = "id,content",
    STAT = "cid,content",
    INVENTORY = "cid,content"

}

RPersist = {

    INTERFACE_SLEEP_MS = 1000,
    SESSION_SLEEP_MS = 1000,

    BUSY_RETRIES = 5

}
