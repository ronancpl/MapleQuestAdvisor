--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

package.path = package.path .. ';?.lua'

require("router.constants.path")
require("router.constants.persistence")
require("utils.logger.error")
require("utils.logger.file")
require("utils.persist.act.call")
require("utils.persist.interface.interface")
require("utils.persist.interface.session")

pcall_log(RPath.TMP_DB .. "/")
tpTableCols = load_db_table_cols()

pRdbms = CRdbmsSession:new({})
pRdbms:set_rdbms_ds(RPersistPath.DB)

setup_persist_interface(pRdbms)
run_persist_interface(pRdbms)
