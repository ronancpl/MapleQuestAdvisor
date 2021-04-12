--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

local CRLF = 20

RStylebox = {
    CRLF = CRLF,

    MIN_X = 250,
    MAX_X = 250,
    FIL_X = 10,
    UPD_X = 115,

    MIN_Y = 80,
    MAX_Y = 200,
    FIL_Y = 10,
    UPD_Y = CRLF,       -- + font height

    WND_LIM_X = 640,
    WND_LIM_Y = 470,

    VW_ITEM = {
        W = 70,
        H = 70
    },

    VW_INVT_ITEM = {
        X = 0,
        Y = 45,

        ST_X = 8,
        ST_Y = 5,
        FIL_X = 4,
        FIL_Y = 2,

        W = 32,
        H = 32
    },

    VW_INVT_SLIDER = {
        X = 158,
        Y = 50,
        W = 10,
        H = 200,

        SEGMENTS = 19
    },

    VW_INVT_THUMB = {
        W = 22,
        H = 14
    },

    VW_INVT_TAB = {
        W = 35,
        H = 20,

        NAME = {
            X = 2,
            Y = 23
        }
    }

}
