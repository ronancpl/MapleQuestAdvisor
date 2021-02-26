--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("router.filters.path")
require("ui.path.path")
require("utils.procedure.string")

function load_xml_node_from_directory(sImgPath, sImgDirPath)
    local pXmlRoot = SXmlProvider:load_xml(RPath.RSC_FIELDS .. "/" .. sImgPath .. ".xml")    -- Wz .img path

    local sImgName = sImgPath:sub(string.rfind(sImgPath, "/")+1, -1)
    pXmlRoot = pXmlRoot:get_child_by_name(sImgName)

    local pXmlNode = pXmlRoot

    local rgsPath = split_path(sImgDirPath)
    for _, sName in ipairs(rgsPath) do
        pXmlNode = pXmlNode:get_child_by_name(sName)
    end

    return pXmlNode
end
