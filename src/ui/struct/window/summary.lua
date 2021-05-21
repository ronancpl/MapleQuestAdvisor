--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

LLayer = {
    NAV_WMAP_BACKGROUND = 1, NAV_WMAP_MAPLINK = 2, NAV_WMAP_MAPLIST = 3, NAV_WMAP_MISC = 4, NAV_WMAP_PTEXT = 5,
    NAV_INVT_TABLE = 1,
    NAV_RSC_TABLE = 1
}

LChannel = {
    OVR_TEXTURE = 2,

    -- Worldmap canvas
    WMAP_BGRD = 1,
    WMAP_LINK_IMG = 1,
    WMAP_MARK_PATH = 1, WMAP_MARK_TBOX = 2, WMAP_MARK_TTIP = 3, WMAP_MARK_TRACE = 4,
    WMAP_PLAINTXT = 2,

    -- Inventory canvas
    INVT_BGRD = 1, INVT_ITEM = 2,

    -- Stat canvas
    STAT_BGRD = 1, STAT_INFO = 2,

    -- Resource canvas
    RSC_BGRD = 1, RSC_ITEM = 2, RSC_DESC = 3

}
