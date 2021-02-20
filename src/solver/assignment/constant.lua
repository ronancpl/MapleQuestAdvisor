--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

RSolver = {
    AP_NUM_TASKS_PER_AGENT = 5,     -- each agent able to take up to N tasks, or more if not enough agents available

    AP_SEQUENCE_ASSIGN = 1,
    AP_SEQUENCE_TICK = 2,
    AP_SEQUENCE_STRIKE = 3,

    AP_CELL_ASSIGN = 1,
    AP_CELL_STRIKE = 2
}
