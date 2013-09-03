################ Au.Map 1.5.1 ReadMe ####################

;~ INTRO

Au stands for Autumn. Au.Map is written in AutoIt and utilizes readProcessMemory and GDI+ to write map information on the Diablo II screen.

Release thread:
http://www.blizzhackers.cc/viewtopic.php?f=171&t=477872

;~ Feautures:

	- Draws lines on Diablo II window which points to warp objects (see next section)
	- Writes serverip
	- Xp Counter
	- Displays playerstats like fcr, ias etc.
	- Chicken
	- Logs ingame messages in a seperate file "Messages", and notifies you if something happens ingame, and your Diablo II isn't active.
	- Remembers game and pass of the previous game and writes under the "game" and "pass" sections when you're @ "Join Game" screen.
	- Writes "Autumn" in big nice letters
	- Item lvl reader.
	- Ingame counter
	- Copies any item selected in Diablo II to clipboard (press CTRL+C)
	- Traps mouse inside the Diablo II screen
	- Reveals current act when hotkey is pressed
	- Opens multiple instances of Diablo, safe.
	- Tp's to town on hotkey.

;~ How do i use it? ###################################

Simply open Autumn.exe. It will create a fresh Settings.ini itself. From here, you will have to choose an already existing Diablo window or open a new one.
Select the one you prefer in the list and press install. Simple as that! You don't have to be ingame or in lobby, it doesn't care.
Alternately, open Au.Compass which has all the same features, however opens in its own window. This might be less intrusive.
If you are having problems, try running Au.Debug.exe (still version 1.2), which opens up a console and debugs too it.

;~ How does it work? ##################################

Au.Map creates an transparant window on top of the Diablo II window, which it uses to draw information on. The window ignores user input, meaning even though the Au.Map window is on top, any keystrokes / mouseclicks will fall onto the Diablo II window.

Au.Map basically does the same as this tutorial on Blizzhackers / EoN: http://www.blizzhackers.cc/viewtopic.php?t=460244 - but doesn't rely on injection using ingamefunctions to draw.
It draws lines to the center of the rooms holding a warp object in the current level. A warp object is: Stairs/entrances, waypoints etc.
This means that the line present doesn't point accurately to an entrance / waypoint, but like ½ screen away.
This also mean that Au.Map isn't able to distinguish between the different lines, so it will point to both stairs + the wp in Durance of Hatred lvl. II

Au.Map's chicken is very simple: It refreshes currentlife and maxlife 30 times / second, and checks whether it's under the current percent set in Settings.ini. If cap is triggered, it will automatically leave the game in ~ .3 seconds. 
The chicken automatically detects extra life (like bo). The chicken is disabled when you're in town. If you want to disable the chicken, set CHICKENPERCENT to -1.
Au.Compass works exactly like Au.Map, however creates it's own window to draw on instead.

;~ Is it safe? ########################################

The point of this maphack was to make it as safe as possible. The standard functions doesn't change or patch Diablo's memory in any way.
The only thing that should be a problem is the maphack function - the standard risks follows with this plugin.

;~ Requirements #######################################

If you run Windows xp, you might want to use Au.Compass instead of the original version.
The layered window effects probably wont work well on Windows Xp / lower versions.
I adjusted the main thread to not eat the cpu to much. Uses 0-3 % on my computer (dual-core x64 1,7 ghz)
Autumn cannot draw on a Diablo if you're running it fullscreen. Recommended to run it windowed in 800x600 mode.
Remember to run as administrator.

;~ Changelog ##########################################
	29/10 '11 - Version 1.5.1 (Beta)
	- Updated to patch 1.13d
	- Added tp'ing to town on hotkey
	- Disabling hotkeys out of game.
	- Some broken features atm, mainly message logging / popping

	21/03 '11 - Version 1.5 (Release)
	- Parameter passing has been reduced to using globals, hopefully helping with some speed.
	- Small fixes and what not (including 50% lesser winapi calls)
	- Chicken code revised to be A LOT quicker (if wanted)
	- Added D2SM as a plugin - Autumn can now reveal the current act.
	- Bit redesign
	- Added the statbox, which shows resistances, speeds like fcr etc.
	- Fixed statreading function (again zomg)
	- Fixed the thing with the boxes losing focus when you click them

	18/12 '10 - Version 1.3.2 (Update)
	- Undeclared variable fix
	- Now works with chars that are level 99 or over
	- The loader detects all windows with the class Diablo II now
	- Some other things i can't remember
	- Added D2Extra as a plugin
	- Fixed the resize function to only resize when necessary.
	- Added an ingame timer.

	18/12 '10 - Version 1.3.1 (Update)
	- Finally fixed the statreading function. This should essentially fix every problem with this program not drawing lines / wrong xp etc.
		As an unfortunate fallback, Autumn is a little heavier on resources now, since it has too scan a lot of more memory
		You can, however, disable both the chicken and the experience counter, which should reduce the cpu load too nearly nothing
	- Fixed storing of window longs to properly enable the "lock labelboxes" function
	- Some minor code improvements and stripping
	- New ability to trap the mouse inside the diablo window, as long as it's active (ALT+Tab out)

	06/12 '10 - Version 1.3 (Release)
	- Redesigned some windows functions like traytip and tooltip to use own funcs.
	- The program now uses the same memory and dll handles throughout execution, which reduces cpu load a lot.
	- Recoded a lot. MUCH BETTER
	- Copies the item the mouse hovers if you press CTRL+C to the clipboard
	- Added a starter gui, which allows to choose between Diablo windows and start new ones (Autumn now supports multiple instances of Diablo!)
	- Included Au.Debug.exe which will help detecting any problems.
	- New program included!
		- Au.Compass is a scaled down version of the original version, which draws on it's own GUI (but it's basically the same)

	5/11 '10 - Version 1.2 (Beta)
	- Added Itemlvl Reader (open up the traymenu)
	- Redesign.
	- Fixed previous bug (again...)
	- Fixed the bug with Au.Map killing innocent windows

	4/11 '10 - Version 1.1.1 (Update)
	- Fixed a bug where Au.Map wouldn't correctly read Diablo II path from the registry.
	- The boxes no longer shows as windows in the traybar.

	4/11 '10 - Version 1.1 (Release)
	- Recoded a lot, so it will be quicker and less cpu-demanding.
	- Added xp-counter.
	- Changed the drawing functions to draw on the minimap, instead of screen.
	- Minmizes / deactives and backwards correctly now
	- Recoded memory algorithms to return correct numbers.
	- Also chickens if you arent moving (whoops!)
	- A lot of aestetichs - labels are now drawn on own windows for the following reasons:
		: You can move them around
		: You can actually read the text.
		: Text wont flicker
	- Pops up traytips if someone joins or leaves your game, or if someone messages you, while your d2 is minimized

	25/10 '10 - Version 1.0 (Release)
	- Initial Release.

;~ Notes ##############################################

Included the font AvQest which is the native font used by Diablo. You install this so Au.Map will look nicer :p Else it will just use Arial font.

;~ Credits ############################################

Rain - For constantly helping me program my shit lol. 
Insolence - For providing Minimized UDF.
Gnarmock - Giving the idea.
Murder567 - for DiaApiConstants and some funcs
Mc God and emjay - providing source and idea for the maphack.
D2BS dev team.

;~ Compiling info #####################################

Compile Autumn.au3.

;~ Written by #########################################

Shaggi, on the operating system Windows 7 in AutoIt ver. 3.3.6.1

################ Au.Map 1.5.1 ReadMe ####################