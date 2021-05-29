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
### Installation steps

#### 1. Download and install the required tools.

  + Download items:

    * Git - Open-source distributed version control system, LuaRocks operates with it - https://git-scm.com/
    * mingw32-gcc - GNU C Compiler, LuaRocks operates with it - https://sourceforge.net/projects/mingw/
    * LuaRocks - Lua modules manager, standalone flavor with Lua interpreter embedded - https://luarocks.github.io/luarocks/releases/
    * LOVE - a graphic interface engine for Lua - https://love2d.org/

    Git and GCC compiler, proceed to install one suitable for your system.

    * Git - download and install with default paths, select-default all options on installation wizard;
    * mingw-get-setup.exe - download and install with default paths, at package catalogue: "All packages" tab -> opt for "mingw32-gcc": "bin" and "dev";

    LuaRocks and LOVE packages selected during development were:

    * luarocks-3.3.1-win32.zip;
    * love-11.3-win64.exe;

  + Install items:

    For expediency later when setting environment variables, it is recommended to use the following install paths:

    * Git - use default install path;
    * Open and install mingw32-gcc, opt to place into "C:\MinGW" (default path);
    * Extract LuaRocks into "C:\Program Files (x86)";
    * Open and install LOVE, opt to place into "C:\Program Files";

  Then, set "MapleQuestAdvisor" the folder on a place of your preference. The selected path will be referred next as `<LOCATION_FOLDER>`.

#### 2. Install LuaRocks

  Find the LuaRocks folder in your file system and, in there, right-click "install.bat", and click "Run as administrator", as you will need admin privileges to install this package manager.

#### 3. Configure environment variables

  + Add into User Variables:
    * LUADATA - `C:\Program Files (x86)\luarocks-3.3.1-win32\win32\lua5.1`

  + Add into System Variables:
    * LUA_CPATH - `%LUADATA%\LuaRocks\lib\lua\5.1\?.dll;c:\program files (x86)\luarocks-3.3.1-win32\win32\lua5.1\lib\lua\5.1\?.dll;`
    * LUA_PATH - `C:\Program Files (x86)\LuaRocks\lua\?.lua;C:\Program Files (x86)\LuaRocks\lua\?\init.lua;%LUADATA%\LuaRocks\share\lua\5.1\?.lua;%LUADATA%\LuaRocks\share\lua\5.1\?\init.lua;c:\program files (x86)\luarocks-3.3.1-win32\win32\lua5.1\share\lua\5.1\?.lua;c:\program files (x86)\luarocks-3.3.1-win32\win32\lua5.1\share\lua\5.1\?\init.lua;`

  + Edit "Path" System Variable, and ADD the following path:
    * Path - `C:\MinGW\bin;C:\Program Files (x86)\luarocks-3.3.1-win32\win32\lua5.1\bin;C:\Program Files (x86)\LuaRocks;%LUADATA%\LuaRocks\bin;C:\Program Files\LOVE;`

#### 4. Install package dependency

Use the now installed LuaRocks to install the required modules.

  + For this, open command prompt (Right-click, "Run as administrator") and type to install each dependency module:
    * `luarocks install luabitop` : bit-to-bit operations.
    * `luarocks install penlight` : STL-like for operating data structures with Lua.
    * `luarocks install xml2lua` : XML parser.
    * `luarocks install --server=https://luarocks.org/dev lua-resty-tarantool` : NoSQL DB connector.

  + Verify whether the packages have been installed by your LuaRocks with: `luarocks list`.

#### 5. Extract XML and images

Use the HaRepacker application, encryption "GMS (old)".

  Select and export each WZ file at a time:

  + For the XMLs, EXPORT (using the "Private Server..." exporting option), to the following location:
    * `<LOCATION_FOLDER>/lib/xml`

  + For the images, EXPORT (using the "PNG/MP3" exporting option), to the following location:
    * `<LOCATION_FOLDER>/ui/media`

  After exporting, at both folder locations should be present therein subfolders ending with ".wz".

---
### Using the tool

This tool is designed to be a standalone, running in Lua.

At the moment, this tool provides 2 running options:
* The quest route skimming
* The graphic UI

To run, open the command prompt and point directory with "cd <LOCATION_FOLDER>\src", then for each running option:

* `> lua5.1 router/main.lua` : runs the quest routing process.
* `> love ui` : opens the UI.

The route skimming runs through a group of quests around the player's level, and displays volume measurement from quests traveled.

It currently runs in route generations. Basing on a player entry (with level, job, current map and inventory/quest/skill data), each generation loads a __board of quests__ that the player is very likely to try. Within the board, quests are selected arbitrarily but in an arranged way, to build a "desirable" path for the player to track.

The UI currently shows canvas samples for several visual components of the application. User-friendly view of quest pathing is WIP.
