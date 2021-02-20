--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

function load_xml_spot(pXmlNode)
    local pOrig = pXmlNode:get_child_by_name("spot")

    local iX = tonumber(pOrig:get("x"))
    local iY = tonumber(pOrig:get("y"))

    return iX, iY
end
