--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

RResourceTabType = {
    GRID = 1,
    PICT = 2,
    INFO = 3
}

RResourceTable = {

    VW_WND = {
        W = 400,
        H = 420
    },

    TAB = {
        MOBS = {TYPE = RResourceTabType.GRID, NAME = "Mobs"},
        ITEMS = {TYPE = RResourceTabType.GRID, NAME = "Items"},
        NPC = {TYPE = RResourceTabType.PICT, NAME = "NPC"},
        FIELD_ENTER = {TYPE = RResourceTabType.INFO, NAME = "Enter"}
    },

    VW_SLIDER = {
        X = 375,
        Y = 50,
        W = 10,
        H = 305
    },

    VW_THUMB = {
        W = 22,
        H = 14
    },

    VW_TAB = {
        W = 50,
        H = 20,

        NAME = {
            X = 20,
            Y = 23
        }
    },

    VW_GRID = {
        ROWS = 6,
        COLS = 4,

        X = 0,
        Y = 45,

        ST_X = 8,
        ST_Y = 5,
        FIL_X = 4,
        FIL_Y = 2,

        W = 32,
        H = 32
    },

    VW_PICT = {
        ROWS = 1,
        COLS = 2,

        X = 0,
        Y = 45,

        ST_X = 8,
        ST_Y = 5,
        FIL_X = 4,
        FIL_Y = 2,

        W = 210,
        H = 200
    },

    VW_INFO = {
        ROWS = 1,
        COLS = 16,

        X = 20,
        Y = 41,

        ST_X = 8,
        ST_Y = 5,
        FIL_X = 4,
        FIL_Y = 2,

        W = 210,
        H = 20
    }

}
