# MapleQuestAdvisor
 A road planning tool for cruising quests in MapleStory

## Head developer: Ronan C. P. Lana

This tool investigates and traces a quest trajectory for a given player at any point in mapling.
Expected inputs range from environment rates, to current player level and completed quests.

### Development information

Status: <span style="color:grey">__In development__</span>.

#### Mission

With non-profitting means intended, provide keen quest-leveling maplers world-wide a quality time with quest management.

#### Vision

By seeking several aspects of utility within quests, look forward to route possibilities for a desirable quest cruising.

#### Values

* Autonomy, seek self-improvement for finding new ways to do a task;
* Orientation, plan ahead and perceive the surroundings to model a smooth activity;
* Aptitude, enjoy the good moments provided throughout the cruise, be active to course-correct in staggering moments;

#### Support MapleQuestAdvisor

If you liked this project, please don't forget to __star__ the repo ;) .

---
### Using the tool

This tool is designed to be a standalone, running in Lua.

At the moment, this tool provides route skimming through a group of quests around the player's level, and displays volume measurement from quests traveled.

It currently runs in route generations. Basing on a player entry (with level, job, current map and inventory/quest/skill data), each generation loads a __board of quests__ that the player is very likely to try. Within the board, quests are selected arbitrarily but in an arranged way, to build a "desirable" path for the player to track.

User-friendly view of quest pathing is WIP.