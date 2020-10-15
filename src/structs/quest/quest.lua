--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("structs.quest.properties")
require("utils.struct.class")

CQuest = createClass({
    iQuestid = -1,
    siStartingLevel = -1,
    qpStart = CQuestProperties:new({iQuestid = -1, bStart = true}),
    qpEnd = CQuestProperties:new({iQuestid = -1, bStart = false})
})

function CQuest:get_quest_id()
    return self.iQuestid
end

function CQuest:get_starting_level()
    return self.siStartingLevel
end

function CQuest:set_starting_level(siLevel)
    self.siStartingLevel = siLevel
end

function CQuest:get_start()
    return self.qpStart
end

function CQuest:get_end()
    return self.qpEnd
end
