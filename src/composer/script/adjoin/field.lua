--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("composer.script.adjoin.field.assign")
require("composer.script.adjoin.field.locate")
require("composer.script.adjoin.util")

function append_field_script_resources(tpDirRscs)
    -- adds functional resources on top of field resources if non-existent

    local tfn_dir_locate = fetch_table_directory_append_method()
    local tfn_dir_ct = fetch_table_directory_append_container()

    for sDirName, tpScriptRscs in pairs(tpDirRscs) do
        local fn_locate = tfn_dir_locate[sDirName]
        if fn_locate ~= nil then
            local bIntUnit = not (sDirName == "event" or sDirName == "portal")  -- ignoring non-mapid map scripts
            local fn_key = fn_get_entry_key(bIntUnit)

            for sScriptName, trgpTypeRscs in pairs(tpScriptRscs) do
                local iScriptid = fn_key(sScriptName)
                if iScriptid ~= nil then
                    for sRscType, rgpRscs in pairs(trgpTypeRscs) do
                        apply_script_field_resources(iScriptid, sRscType, rgpRscs, fn_locate, tfn_dir_ct)
                    end
                end
            end
        end
    end
end
