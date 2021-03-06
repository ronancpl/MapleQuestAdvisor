--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

function load_xml_text_box(pXmlNode)
    local pXmlTitle = pXmlNode:get_child_by_name("title")
    local pXmlDesc = pXmlNode:get_child_by_name("desc")

    if pXmlTitle == nil and pXmlDesc == nil then  -- empty content
        return nil
    end

    local sTitle = pXmlTitle and pXmlTitle:get_value() or ""
    local sDesc = pXmlDesc and pXmlDesc:get_value() or ""
    return sTitle, sDesc
end
