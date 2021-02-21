--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

function load_xml_node_from_directory(sDirPath)
    local sImgXmlPath
    local sImgDirNodePath

    local i = string.find(sDirPath, ".img")
    sImgXmlPath = string.sub(sDirPath, 1, i)
    sImgDirNodePath = string.sub(sDirPath, i + 4, -1)

    local pImgXmlNode = SXmlProvider:load_xml(sImgXmlPath)
    local rgsSubNames = split_text(sImgDirNodePath)

    local pXmlNode = pImgXmlNode
    for _, sName in ipairs(rgsSubNames) do
        pXmlNode = pXmlNode:get_child_by_name(sName)
    end

    return pXmlNode
end
