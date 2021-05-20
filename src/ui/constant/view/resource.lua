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
        H = 420,

        VW_FIELD = {
            FIL_X = 5,
            FIL_Y = 5,
            W = 285,
            H = 320
        }
    },

    TAB = {
        MOBS = {ID = 1, TYPE = RResourceTabType.GRID, NAME = "Mobs"},
        ITEMS = {ID = 2, TYPE = RResourceTabType.GRID, NAME = "Items"},
        NPC = {ID = 3, TYPE = RResourceTabType.PICT, NAME = "NPC"},
        FIELD_ENTER = {ID = 4, TYPE = RResourceTabType.INFO, NAME = "Enter"}
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

    VW_BASE = {
        MOBS = {
            W = 80,
            H = 80
        },
        ITEMS = {
            W = 32,
            H = 32
        },
        NPCS = {
            W = 210,
            H = 200
        }
    },
    VW_GRID = {
        MOBS = {
            ROWS = 3,
            COLS = 4,

            X = 20,
            Y = 45,

            ST_X = 15,
            ST_Y = 5,
            FIL_X = 4,
            FIL_Y = 2,

            W = 80,
            H = 80
        },
        ITEMS = {
            ROWS = 6,
            COLS = 8,

            X = 20,
            Y = 45,

            ST_X = 15,
            ST_Y = 5,
            FIL_X = 4,
            FIL_Y = 2,

            W = 32,
            H = 32
        },
        NPCS = {
            ROWS = 1,
            COLS = 2,

            X = 20,
            Y = 45,

            ST_X = 15,
            ST_Y = 5,
            FIL_X = 4,
            FIL_Y = 2,

            W = 100,
            H = 100
        },
        FIELD_ENTER = {
            ROWS = 1,
            COLS = 16,

            X = 20,
            Y = 45,

            ST_X = 15,
            ST_Y = 5,
            FIL_X = 4,
            FIL_Y = 2,

            W = 210,
            H = 20
        }
    },
    VW_GRID_MINI = {
        W = 280,
        H = 280,

        FIL_X = 4,
        FIL_Y = 4,

        MOBS = {
            ROWS = 3,
            COLS = 4,

            ST_X = 15,
            ST_Y = 15,
            FIL_X = 4,
            FIL_Y = 4,

            W = 24,
            H = 24
        },
        ITEMS = {
            ROWS = 3,
            COLS = 4,

            ST_X = 15,
            ST_Y = 15,
            FIL_X = 4,
            FIL_Y = 4,

            W = 24,
            H = 24
        },
        NPCS = {
            ROWS = 1,
            COLS = 2,

            ST_X = 15,
            ST_Y = 15,
            FIL_X = 4,
            FIL_Y = 4,

            W = 42,
            H = 42
        },
        FIELD_ENTER = {
            ROWS = 3,
            COLS = 1,

            ST_X = 10,
            ST_Y = 10,
            FIL_X = 4,
            FIL_Y = 5,

            W = 134,
            H = 20
        }
    }
}
