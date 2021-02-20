--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

function apply_script_field_resources(iScriptid, sRscType, rgpRscs, fn_locate, tfn_dir_ct)
    local rgiMapids = fn_locate(iScriptid)

    local ctItem = tfn_dir_ct[sRscType]
    if ctItem ~= nil then
        for _, pRsc in ipairs(rgpRscs) do
            local iSrcid = pRsc:get_id()
            ctItem:add_entry(iSrcid)

            for _, iMapid in ipairs(rgiMapids) do
                ctItem:add_location(iSrcid, iMapid)
            end
        end
    end
end
