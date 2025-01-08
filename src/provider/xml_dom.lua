--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

function xml_readitem(sItem, bMode)
    local iIdx = string.find(sItem, "=")
    if iIdx == nil then iIdx = #sItem end

    local sName = sItem:sub(0,iIdx - 1)
    local sValue = sItem:sub(iIdx + 2, bMode and -3 or -2)

    return sName, sValue
end

function xml_readline(sLine)
    local iIdx = 0
    local rgsStr = {}

    local iLeft = string.find(sLine, "<") + 1
    local iRight = string.rfind(sLine, ">") - 1

    iIdx = string.find(sLine, " ", iLeft) or iRight + 1
    table.insert(rgsStr, sLine:sub(iLeft,iIdx))

    while iIdx < iRight do
        local iIdx2
        local iIdx3
        local i

        i = string.find(sLine, "=", iIdx)
        if i == nil then
            iIdx2 = iIdx
            iIdx3 = iRight
        else
            iIdx2 = string.rfind(sLine, " ", i - 1)
            if iIdx2 == nil then iIdx2 = iLeft end
            iIdx2 = math.max(iIdx2 + 1,iIdx)

            iIdx3 = string.find(sLine, " ", i + 1)
            if iIdx3 == nil then iIdx3 = iRight end
            iIdx3 = math.min(iIdx3 - 1,iRight)

            local iIdxA = string.find(sLine, "\"", i + 1)
            if iIdxA < iIdx3 then
                iIdx3 = string.find(sLine, "\"", iIdxA + 1)
            end
        end

        local sItem = sLine:sub(iIdx2,iIdx3)
        table.insert(rgsStr, sItem)

        iIdx = iIdx3 + 1
    end

    return rgsStr
end

function xml_readsequence(rgsLines, iIdx)
    local sText

    local i = iIdx
    local nLines = #rgsLines
    while i <= nLines do
        local sLine = rgsLines[i]
        if i == iIdx then
            sText = sLine
        else
            sText = sText .. " " .. sLine
        end

        local iRight = string.rfind(sLine, ">")
        if iRight ~= nil then
            break
        end

        i = i + 1
    end

    return sText, i
end

function xml_node(rgsStr)
    local pNode = {}

    for _, sStr in ipairs(rgsStr) do
        local sName, pVal = xml_readitem(sStr,string.ends_with(sStr," "))
        pNode[sName] = pVal
    end

    pNode[1] = xml_readitem(rgsStr[1],false)    -- node type

    return pNode
end

function xml_node_attributes(pFileNode)
    local tpAttr = {}
    local rgpChildren = {}

    for sKey, pVal in pairs(pFileNode) do
        tpAttr[sKey] = pVal
    end

    pFileNode["_type"] = pFileNode[1]
    pFileNode["_name"] = pFileNode[1]
    pFileNode["_attr"] = tpAttr
    pFileNode["_children"] = rgpChildren
end

function xml_dom(pTree, rgsLines, iIdx)
    local i = iIdx
    while i <= #rgsLines do
        local sText
        sText, i = xml_readsequence(rgsLines, i)
        local rgsStr = xml_readline(sText)
        if rgsStr[1]:starts_with("imgdir") or rgsStr[1]:starts_with("canvas") then
            local pNewTree = xml_node(rgsStr)
            xml_node_attributes(pNewTree)

            if pNewTree["name"] == nil then pNewTree["name"] = "" end
            table.insert(pTree, pNewTree)

            iIdx = xml_dom(pNewTree["_children"], rgsLines, i + 1)
            i = iIdx - 1
        elseif rgsStr[1]:starts_with("/imgdir") or rgsStr[1]:starts_with("/canvas") then
            iIdx = i
            break
        else
            local pNode = xml_node(rgsStr)
            if pNode["name"] == nil then pNode["name"] = "" end

            xml_node_attributes(pNode)
            table.insert(pTree, pNode)
        end

        i = i + 1
    end

    return iIdx + 1
end

function parse_xml_file(sFileName)
    local pTree = xml_node({"ROOT ","name=\"\""})
    local pLines = io.open("../" .. sFileName, "r"):lines()

    local rgsLines = {}
    for sLine in pLines do
        table.insert(rgsLines, sLine)
    end

    xml_node_attributes(pTree)
    xml_dom(pTree["_children"], rgsLines, 1)

    return pTree
end
