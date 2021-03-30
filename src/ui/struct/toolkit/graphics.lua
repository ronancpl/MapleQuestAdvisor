--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

function graphics_draw(pImg, iPx, iPy, iR, iW, iH, iOx, iOy, iKx, iKy)
    local fSw, fSh
    if iW ~= nil or iH ~= nil then
        local iWidth
        local iHeight
        iWidth, iHeight = pImg:getDimensions()

        if iW ~= nil then
            fSw = iW / iWidth

            if iH ~= nil then
                fSh = iH / iHeight
            else
                fSh = fSw
            end
        else
            fSh = iH / iHeight
            fSw = fSh
        end
    end

    love.graphics.draw(pImg, iPx, iPy, iR, fSw, fSh, iOx, iOy, iKx, iKy)
end
