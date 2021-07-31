--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("router.procedures.persist.delete.rates")
require("router.procedures.persist.load.rates")
require("router.procedures.persist.save.rates")

function run_rates_bt_load(pUiStats, pPlayer)
    load_rates(pUiStats, pPlayer)
end

function run_rates_bt_save(pUiStats)
    save_rates(pUiStats)
end

function run_rates_bt_delete(pUiStats)
    delete_rates(pUiStats)
end
