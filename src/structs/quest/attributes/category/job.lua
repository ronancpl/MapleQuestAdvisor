--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

local function is_in_job_class_tree(siBaseJobBranch, siJobBranch, depth)
    local siNextBaseBranch = math.floor(siBaseJobBranch / 10)
    local siNextJobBranch = math.floor(siJobBranch / 10)
    if siNextBaseBranch == siNextJobBranch then
        return siNextJobBranch ~= 0 or depth < 3
    elseif siNextJobBranch ~= 0 then
        return is_in_job_class_tree(siNextBaseBranch, siNextJobBranch, depth + 1)
    else
        return false
    end
end

function is_in_job_tree(siBaseJobid, siJobid)
    if siBaseJobid > siJobid then
        return false
    end

    local siBaseBranch = math.floor(siBaseJobid / 10)
    local siJobBranch = math.floor(siJobid / 10)
    if siBaseBranch == siJobBranch then
        return true
    else
        local siBaseClass = math.floor(siBaseJobid / 100)
        local siJobClass = math.floor(siJobid / 100)

        if siBaseClass ~= siJobClass and siBaseClass % 10 ~= 0 then
            return false
        else
            return is_in_job_class_tree(siBaseBranch, siJobBranch, 1)
        end
    end
end

local function get_job_niche(siJobid)
    return math.floor(siJobid / 100) % 10;
end

function is_in_job_niche(siBaseJobid, siJobid)
    return get_job_niche(siBaseJobid) == get_job_niche(siJobid)
end
